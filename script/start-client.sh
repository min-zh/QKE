#!/usr/bin/env bash
echo $(date "+%Y-%m-%d %H:%M:%S") "===start start client==="
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")


source "${K8S_HOME}/script/common.sh"
export KUBECONFIG="/etc/kubernetes/admin.conf"

echo $(date "+%Y-%m-%d %H:%M:%S") "reload authorized keys"
rm /root/.ssh/authorized_keys
ln -fs /data/authorized_keys /root/.ssh/authorized_keys
echo $(date "+%Y-%m-%d %H:%M:%S") "ensure dir"
ensure_dir
echo $(date "+%Y-%m-%d %H:%M:%S") "swapoff"
swapoff -a
echo $(date "+%Y-%m-%d %H:%M:%S") "copy pki from master1"
scp root@master1:/etc/kubernetes/admin.conf /root/.kube/config
cp /root/.kube/config /etc/kubernetes/admin.conf

echo $(date "+%Y-%m-%d %H:%M:%S") "Install KubeSphere"
if [ ! -f "${CLIENT_INIT_LOCK}" ]; then
    echo $(date "+%Y-%m-%d %H:%M:%S") "Install Cloud Controller Manager"
    install_cloud_controller_manager
    echo $(date "+%Y-%m-%d %H:%M:%S") "Install KubeSphere"
    install_kubesphere
    echo $(date "+%Y-%m-%d %H:%M:%S") "Finish install KubeSphere"
    touch ${CLIENT_INIT_LOCK}
fi

echo $(date "+%Y-%m-%d %H:%M:%S") "===end start client==="