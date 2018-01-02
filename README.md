# WorkBook

Small tool for boosting UI development. Usually I use this tool for checking UI behaviour without recompilation.

![Demo of usage](https://github.com/akantsevoi/WorkBook/blob/master/Demo/example.gif?raw=true)

Carthage install
```
github "akantsevoi/WorkBook"
```

Usage

run node.js server:
```
node server.js
```

open workbook:
```
open workbook.html
```

Create WorkBookBinder and subscribe on changes:
```
binder = WorkbookBinder<ModelType>(value: initialValue, resourceKey: "myModelKey")

binder.subscribe { (newModel) in
            // TODO: update UI
        }
```

ModelType - any Codable type

`resourceKey` should be unique. 

Default host for server, Workbook.html and WorkBookBinder is `localhost:1337`
For change it on library side use
```
WorkBookConstants.basePath = "ws://localhost:5001"
```
