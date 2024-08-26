package com.github.diegopacheco.sandboxspring.config;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.binder.MeterBinder;
import io.micrometer.core.instrument.binder.netty4.NettyAllocatorMetrics;
import io.micrometer.core.instrument.binder.netty4.NettyEventExecutorMetrics;
import io.netty.buffer.UnpooledByteBufAllocator;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.group.ChannelGroup;
import io.netty.channel.group.DefaultChannelGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.util.concurrent.GlobalEventExecutor;
import org.springframework.boot.web.embedded.netty.NettyReactiveWebServerFactory;
import org.springframework.boot.web.embedded.netty.NettyServerCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.ReactorResourceFactory;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import reactor.netty.resources.LoopResources;

import java.util.Collections;

/**
 * From micrometer perspective I saw no difference, looks like is not needed.
 */
@Configuration
public class NettyConfig implements MeterBinder {

    @Override
    public void bindTo(MeterRegistry registry) {
        new NettyEventExecutorMetrics(nioEventLoopGroup()).bindTo(registry);
        new NettyAllocatorMetrics(unpooledByteBufAllocator()).bindTo(registry);
    }

    @Bean
    public UnpooledByteBufAllocator unpooledByteBufAllocator() {
        return UnpooledByteBufAllocator.DEFAULT;
    }

    @Bean
    public NioEventLoopGroup nioEventLoopGroup() {
        return new NioEventLoopGroup(4);
    }

    @Bean
    public ChannelGroup channelGroup() {
        return new DefaultChannelGroup(GlobalEventExecutor.INSTANCE);
    }

    @Bean
    public ReactorResourceFactory reactorResourceFactory(NioEventLoopGroup eventLoopGroup) {
        ReactorResourceFactory f= new ReactorResourceFactory();
        f.setLoopResources(new LoopResources() {
            @Override
            public EventLoopGroup onServer(boolean b) {
                return eventLoopGroup;
            }
        });
        f.setUseGlobalResources(false);
        return f;
    }

    @Bean
    public ReactorClientHttpConnector reactorClientHttpConnector(ReactorResourceFactory r) {
        return new ReactorClientHttpConnector(r, m -> m);
    }

    @Bean
    public NettyReactiveWebServerFactory factory(NioEventLoopGroup eventLoopGroup,
                                                 ChannelGroup channelGroup
    ) {
        NettyReactiveWebServerFactory factory = new NettyReactiveWebServerFactory();
        factory.setServerCustomizers(Collections.singletonList((NettyServerCustomizer) httpServer ->
                httpServer.tcpConfiguration(tcpServer ->
                        tcpServer.runOn(eventLoopGroup)
                                .channelGroup(channelGroup)
                )
        ));
        return factory;
    }

}
