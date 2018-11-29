# JKA RPMod server based on OpenJK
FROM jediholo/rpmod-game
LABEL maintainer="Fabien Crespel <fabien@crespel.net>"

# Environment
ENV OJK_OPTS="+set fs_basegame JEDI +exec server.cfg"

# Files
COPY ./root /
RUN chmod +x /opt/openjk/*.sh
