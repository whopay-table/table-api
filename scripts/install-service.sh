
pwd | sed -e 's/\//\\\//g' | eval "sed -e 's/{{PWD}}/$(cat -)/g' ./scripts/table-api.service" > /etc/systemd/system/table-api.service
systemctl enable table-api
