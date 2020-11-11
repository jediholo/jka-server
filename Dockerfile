# JKA RPMod server based on OpenJK
FROM docker.crespel.me/jediholo/rpmod-game:0.5.1
LABEL maintainer="Fabien Crespel <fabien@crespel.net>"

# Environment
ENV OJK_OPTS="+set fs_basegame JEDI +exec server.cfg"

# Files
COPY ./root /
RUN chmod +x /opt/openjk/*.sh
