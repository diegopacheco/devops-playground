FROM flink:1.19-java17
USER root
RUN apt-get update && apt-get install -y curl wget maven openjdk-17-jdk && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
WORKDIR /opt/flink/lib
RUN curl -L -o sedona-flink-shaded_2.12-1.7.1.jar https://repo1.maven.org/maven2/org/apache/sedona/sedona-flink-shaded_2.12/1.7.1/sedona-flink-shaded_2.12-1.7.1.jar && \
curl -L -o geotools-wrapper-1.7.1-28.5.jar https://repo1.maven.org/maven2/org/datasyslab/geotools-wrapper/1.7.1-28.5/geotools-wrapper-1.7.1-28.5.jar
COPY flink-sedona-app /app
WORKDIR /app
RUN mvn clean package -DskipTests
RUN mkdir -p /opt/flink/usrlib && cp target/flink-sedona-app-1.0.jar /opt/flink/usrlib/
WORKDIR /opt/flink
USER flink
