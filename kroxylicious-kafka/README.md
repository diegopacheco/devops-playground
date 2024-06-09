### Kroxylicious

Proxy for Kafka: KMS encryption and decryption for Kafka messages on the proxy.

### How to

1. Start Kroxylicious
```bash
./bin/kroxylicious-start.sh --config config/example-proxy-config.yml
```
```
❯ ./bin/kroxylicious-start.sh --config config/example-proxy-config.yaml
/mnt/e35d88d4-42b9-49ea-bf29-c4c3b018d429/diego/bin/kroxylicious-app-0.6.0/bin /mnt/e35d88d4-42b9-49ea-bf29-c4c3b018d429/diego/bin/kroxylicious-app-0.6.0
exec java -Dlog4j2.configurationFile=/mnt/e35d88d4-42b9-49ea-bf29-c4c3b018d429/diego/bin/kroxylicious-app-0.6.0/bin/../config/log4j2.yaml -XX:+ExitOnOutOfMemoryError -cp /mnt/e35d88d4-42b9-49ea-bf29-c4c3b018d429/diego/bin/kroxylicious-app-0.6.0/bin/../libs/* io.kroxylicious.app.Kroxylicious --config config/example-proxy-config.yaml
/mnt/e35d88d4-42b9-49ea-bf29-c4c3b018d429/diego/bin/kroxylicious-app-0.6.0
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -                  .:---:.
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -              -*@@@@@@@@@@%++*##*+:
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -            -@@%=:.      :=%@*++#@@%-         :=++- .+%%%#=
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -           -@@-    .        +     *@@-:::---=#@@%@@@@@%=+@@#
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -           #@=    -@+        .     @@@@@@@@@%%%:  +==-   *@@
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -        :*@@@.    .+:              ...                   #@@
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -       #@@*: .                                           @@#
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -      %@@:                                              =@@-
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -     =@@:                                               %@%
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -     *@@                                             :-*@@-
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -     +@@          -                       .:--=**##*%@=@@#
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -     :@@=   .    +@%+-.     ..:--=++*####*#-  =+..:-*@%@@.
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -      %@@   =-    . :=+*****++==-:..  .:-=+@+ #@@@@@@@@@:
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -      :@@+   %=              .:-=+#%@@@@@@%#@#@@-.  :@%.
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -       *@@:  .%%+-:::--=+*#%%*+-:+@@*-:.    -@@%     =
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -        %@%    -*#%%##*=-:       .@@=        .#+
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -     -**%@@-                     -@@-          .      .:
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -    *@@**%@=                     %@@                .*@+
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -    -@@#-                       -@@-              :*@@@#
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -     .*@@#        .             %@%            :+%@@*@@#
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -     :%@%.       .=  =         .@@*. .::==+++#@@@*-  @@*
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -    =@@#         :**#:         :@@@@@@@@@@@#%#=:    *@@.
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -   *@@=                        :@*-:+:.- .--:.     +@@=
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -  %@@: .:                       #%===**#++       :#@@-
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 - :@@+.  -#*-      *=             -.-= :        :#@@*.
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -  =%@@@@@@@@@#=..%+                         :+%@@*:
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -     :::::::+#@@@+                     :=+%@@@*-
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -              *@@  .:=##*+======++*#%@@@@%*=.
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -              :%@@@@@@#*##%%@@@%%##*+=-.
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:47 -                .--:.
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:82 - kroxylicious: 0.6.0
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:82 - commit id: 51c1ade15df644009926c04a2e41e06a2a966dd5
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:82 - commit message: Release version v0.6.0
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:91 - Platform: Java 21.0.2+13-LTS(Amazon.com Inc.) running on Linux 6.2.0-1009-lowlatency/amd64
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.model.VirtualCluster:80 - Virtual Cluster: demo, Downstream localhost:9192 => Upstream localhost:9092
2024-06-09 00:25:29 <main> INFO  io.kroxylicious.proxy.StartupShutdownLogger:100 - Kroxylicious is starting
2024-06-09 00:25:30 <main> INFO  io.kroxylicious.proxy.KafkaProxy:186 - Binding metrics endpoint: 0.0.0.0:9190
```

2. Start Zookeeper
```
bin/zookeeper-server-start.sh config/zookeeper.properties
```
3. Start Kafka
```
bin/kafka-server-start.sh config/server.properties
```
4. Create a topic
```
export KROXYLICIOUS_BOOTSTRAP=localhost:9192
bin/kafka-console-consumer.sh --topic topic_kl --from-beginning --bootstrap-server $KROXYLICIOUS_BOOTSTRAP
```
5. Send message
```
export KROXYLICIOUS_BOOTSTRAP=localhost:9192
 echo "hello world" | bin/kafka-console-producer.sh --topic topic_kl --bootstrap-server $KROXYLICIOUS_BOOTSTRAP
```
6. Consume message
```
bin/kafka-console-consumer.sh --topic topic_kl --from-beginning --bootstrap-server $KROXYLICIOUS_BOOTSTRAP
```