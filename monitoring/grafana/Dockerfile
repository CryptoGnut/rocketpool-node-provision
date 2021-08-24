FROM grafana/grafana

USER root
RUN apk add wget
RUN apk add tree
RUN apk add jq
RUN apk add sed
RUN apk add gettext

RUN mkdir -p /etc/grafana/provisioning/dashboards/
RUN mkdir -p /etc/grafana/provisioning/datasources/
COPY ./dashboard.yml /etc/grafana/provisioning/dashboards/
COPY ./datasource.yml /etc/grafana/provisioning/datasources/

#  prysm_metanull
ARG prysm_metanull_url='https://raw.githubusercontent.com/metanull-operator/eth2-grafana/master/eth2-grafana-dashboard-single-source-beacon_node.json'
ARG prysm_metanull_file='/etc/grafana/provisioning/dashboards/prysm_metanull.json'
RUN wget -qcO - $prysm_metanull_url | jq '.title = "prysm_metanull"' >$prysm_metanull_file

#  prysm_less_10
ARG prysm_less_10_url='https://raw.githubusercontent.com/GuillaumeMiralles/prysm-grafana-dashboard/master/less_10_validators.json'
ARG prysm_less_10_file='/etc/grafana/provisioning/dashboards/prysm_less_10.json'
RUN wget -qcO - $prysm_less_10_url | jq '.title = "prysm_less_10"' >$prysm_less_10_file

#  prysm_more_10
ARG prysm_more_10_url='https://raw.githubusercontent.com/GuillaumeMiralles/prysm-grafana-dashboard/master/more_10_validators.json'
ARG prysm_more_10_file='/etc/grafana/provisioning/dashboards/prysm_more_10.json'
RUN wget -qcO - $prysm_more_10_url | jq '.title = "prysm_more_10"' >$prysm_more_10_file

# prysm_ynager
ARG prysm_ynager_url='https://raw.githubusercontent.com/ynager/grafana-eth-staking/main/dashboard.json'
ARG prysm_ynager_file='/etc/grafana/provisioning/dashboards/prysm_ynager.json'
RUN wget -qcO - $prysm_ynager_url | jq '.title = "prysm_ynager"' >$prysm_ynager_file

# geth
ARG geth_url='https://grafana.com/api/dashboards/14053/revisions/1/download'
ARG geth_file='/etc/grafana/provisioning/dashboards/geth.json'
RUN wget -qcO - $geth_url | jq '.title = "geth"' >$geth_file
RUN sed -i -e 's/\${DS_PROMETHEUS}/Prometheus/g' $geth_file
RUN sed -i -e 's/\${VAR_JOB}/geth/g' $geth_file
RUN tree /etc/grafana/provisioning/

ENTRYPOINT [ "/run.sh" ]