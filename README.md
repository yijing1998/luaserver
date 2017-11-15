# What's luaserver?
*luaserver* 是一个基于 *luasocket* 的、纯 *lua* 实现的、单线程 *tcp* 服务器框架。它能够管理多个 *tcp* 连接，接收 *tcp* 数据，发送 *tcp* 数据。  
# Application scenarios
*c/s* 程序测试  
低负载的服务端应用  
嵌入式设备服务端应用  
例：已实现 relp 协议服务端，并安装在 *Xiaomi mini router* 上，能够接收并保存 *Aws* 虚拟主机日志。
# prerequisite
*lua 5.1* 以上  
*luasocket*  
*luasql-sqlite3*（如果使用 *module*: `recipe.rawlog_db`）
# module introduction
## 服务器模块
`srv.noreply`: 只接收数据，不发送数据。  
`srv.normal`: 接收和发送数据。
## 数据处理模块
`parser.raw`: 对数据不做任何处理。  
`parser.echo`: 把接收到的数据原样送回。  
`parser.relp`: *relp* 协议的服务端实现。（参考 [RELP - The Reliable Event Logging Protocol](http://www.rsyslog.com/doc/relp.html)）
## 信息处理模块
数据处理模块获取的信息由本模块处理  
`recipe.term`: 把信息打印至终端。  
`recipe.rawlog_db.lua`: 把 *rsyslog* 信息保存至数据库。
# How to use luaserver?
创建 *.lua* 文件，根据需求选择所需的 `srv`、`parser`、`recipe`，设置好各模块参数后，调用 `s:start()` 启动服务。或直接使用实例文件：*t1.lua* 和 *t2.lua*。你也可以编写自己的 `srv`、`parser`、`recipe`。  
*shell* 环境下，执行 `lua yoursvr.lua`
# Next step
问题1. `srv` 模块与 `parser` 模块之间只能传递 *tcp* 数据，`srv` 未提供机制接收 `parser` 的控制信息（如 *close* 等控制信息），`srv` 不能根据 `parser` 的反馈进行动态调整。  
问题2. 未提供用户界面，`srv` 设置不能在线调整。  
问题3. 单线程，响应请求不及时。