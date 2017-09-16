
pwd | sed -e 's/\//\\\//g' | eval "sed -e 's/{{PWD}}/$(cat -)/g' ./scripts/table-web.service" > /etc/systemd/system/table-api.service
systemctl enable table-api
