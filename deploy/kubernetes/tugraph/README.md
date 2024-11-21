## What does this do

This gets a TuGraph v3.5.0 service running on the K3s node, and exposes port `30687` for TuGraph bolt client access.

## How to maintain this

The current values file is based on this guideline in [TuGraph - Docker Deployment (2024-08-16 snapshot)](https://web.archive.org/web/20240816031030/https://tugraph-db.readthedocs.io/zh-cn/latest/5.installation&running/3.docker-deployment.html):

```shell
docker run -d -p 7070:7070  -p 7687:7687 -p 9090:9090 -v /root/tugraph/data:/var/lib/lgraph/data  -v /root/tugraph/log:/var/log/lgraph_log \
 --name tugraph_demo reg.docker.alibaba-inc.com/fma/tugraph-runtime-centos7:${VERSION}

# 7070是默认的http端口，访问tugraph-db-browser使用。
# 7687是bolt端口，bolt client访问使用。
# 9090是默认的rpc端口，rpc client访问使用。
# /var/lib/lgraph/data是容器内的默认数据目录，/var/log/lgraph_log是容器内的默认日志目录
# 命令将数据目录和日志目录挂载到了宿主机的/root/tugraph/上进行持久化，您可以根据实际情况修改。
```

If you need to upgrade from TuGraph v3.5.0 to a higher version. Please also update `tugraph.yaml` according to the latest guideline in TuGraph documentations.

Currently, Crates Pro depends on TuGraph v3.5.0, since it indirectly depends on Rust crate `libtugraph-sys=0.1.2+3.5.0`, so don't change the version unless this situation changes.
