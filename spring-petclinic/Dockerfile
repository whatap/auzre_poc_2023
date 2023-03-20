FROM openjdk:17-alpine

ADD ./target /app/petclinic
ADD ./whatap /whatap
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN echo "whatap.server.host=ec2-54-180-154-217.ap-northeast-2.compute.amazonaws.com" >> /whatap/whatap.conf

ENV JAVA_OPTS=" -javaagent:/whatap/whatap.agent-2.2.0.jar --add-opens=java.base/java.lang=ALL-UNNAMED "

CMD ["/entrypoint.sh"]