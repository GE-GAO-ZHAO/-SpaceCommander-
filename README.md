
# 检查原理

首先会在项目目录中会添加有一个安装脚本：`format-check.sh`，此脚本添加到项目目录中并添加到git跟踪，同步到每个人的本地代码目录；同时会在XCode编译选项中添加脚本执行命令，在编译时自动执行安装检查并安装

![format-check](https://tva1.sinaimg.cn/large/007S8ZIlly1geqzb6knhpj30fa072wfd.jpg)

XCode 中增加相应的脚本执行配置，在编译时执行脚本自动安装，避免新clone下来的项目没有安装脚本检查，提交了不合规范的代码

![XCode](https://tva1.sinaimg.cn/large/007S8ZIlly1geqz22p202j30hj03bjrq.jpg)

执行此脚本后会在`.git/hook/`中添加了一个pre-commit的脚本，这个pre-commit会在你每次要commit代码之前，git都会去找有没有这个文件。如果有这个文件，那么就去文件里执行一些特定的shell脚本，比如我们的pre-commit是去/.format-check/目录下执行`format-objc-hook`脚本

## .clang-format配置

在当前目录下添加了.clang-format文件，这个文件主要是做什么的呢?
其主要是设定了代码的一些风格.

```shell
# Custom options in the special build of clang-format (these are not standard options)
IndentNestedBlocks: false
AllowNewlineBeforeBlockParameter: false

Language: Cpp
BasedOnStyle:  LLVM
AccessModifierOffset: -1
ConstructorInitializerIndentWidth: 4
SortIncludes: false

AlignAfterOpenBracket: true
AlignEscapedNewlinesLeft: true
AlignOperands: false
AlignTrailingComments: true

AllowAllParametersOfDeclarationOnNextLine: false
AllowShortBlocksOnASingleLine: false
AllowShortCaseLabelsOnASingleLine: false
AllowShortFunctionsOnASingleLine: false
AllowShortIfStatementsOnASingleLine: false
AllowShortFunctionsOnASingleLine: false
AllowShortLoopsOnASingleLine: false

AlwaysBreakAfterDefinitionReturnType: false
AlwaysBreakTemplateDeclarations: false
AlwaysBreakBeforeMultilineStrings: false

BreakBeforeBinaryOperators: None
BreakBeforeTernaryOperators: false
BreakConstructorInitializersBeforeComma: false

BinPackArguments: true
BinPackParameters: true
ColumnLimit: 0
ConstructorInitializerAllOnOneLineOrOnePerLine: true
DerivePointerAlignment: false
ExperimentalAutoDetectBinPacking: false
IndentCaseLabels: true
IndentWrappedFunctionNames: false
IndentFunctionDeclarationAfterType: false
MaxEmptyLinesToKeep: 2
KeepEmptyLinesAtTheStartOfBlocks: false
NamespaceIndentation: Inner
ObjCBlockIndentWidth: 4
ObjCSpaceAfterProperty: true
ObjCSpaceBeforeProtocolList: true
PenaltyBreakBeforeFirstCallParameter: 10000
PenaltyBreakComment: 300
PenaltyBreakString: 1000
PenaltyBreakFirstLessLess: 120
PenaltyExcessCharacter: 1000000
PenaltyReturnTypeOnItsOwnLine: 200
PointerAlignment: Right
SpacesBeforeTrailingComments: 1
Cpp11BracedListStyle: true
Standard:        Auto
IndentWidth:     4
TabWidth:        8
UseTab:          Never
BreakBeforeBraces: Custom
BraceWrapping:
    AfterClass: false
    AfterControlStatement: false
    AfterEnum: false
    AfterFunction: false
    AfterNamespace: false
    AfterObjCDeclaration: false
    AfterStruct: false
    AfterUnion: false
    BeforeCatch: false
    BeforeElse: false
    IndentBraces: false

SpacesInParentheses: false
SpacesInSquareBrackets: false
SpacesInAngles:  false
SpaceInEmptyParentheses: false
SpacesInCStyleCastParentheses: false
SpaceAfterCStyleCast: false
SpacesInContainerLiterals: true
SpaceBeforeAssignmentOperators: true

ContinuationIndentWidth: 4
CommentPragmas:  '^ IWYU pragma:'
ForEachMacros:   [ foreach, Q_FOREACH, BOOST_FOREACH ]
SpaceBeforeParens: ControlStatements
DisableFormat:   false
```

效果就是比如将

`AllowShortFunctionsOnASingleLine:false`

那么这样风格的代码

```objc
int f() { return 0; }
```

将是不允许的，
需要改成这样的才能通过规则

```objc
int f() {
    return 0;
}
```

## Git Hook

另一个是在/AwesomeCommand/.git/hook/中添加了一个pre-commit的脚本，那么这个pre-commit是干什么的呢，很简单,这个东西就是在你每次要commit代码之前，git都会去找有没有这个文件。如果有这个文件，那么就去文件里执行一些特定的shell脚本，比如我们的pre-commit是去/.format-check/目录下执行`format-objc-hook`脚本

至此，我们就完成了一个代码风格审查工具的部署，如果团队想要制定代码风格的话只需要修改和`.git`同目录下的`.clang-format`文件就好，具体的规则可以参考[这个](http://clangformat.com/)，每种样式点击一下会弹出相应的实例代码。［不过要记得.gitignore中需要把.clang-fotmat去掉,这样只需要由一个人制定好了规则每个人pull一下就OK了］。同时只需要把刚刚download下来的format-check文件放到相应的组件文件夹下执行一边就可以完成全部组件的代码风格部署。

# 使用示例

修改代码，其中if语句括号、方法间换行行数等存在风格差异

![precommit](https://tva1.sinaimg.cn/large/007S8ZIlly1geqx2c9tpfj31270jctav.jpg)

对以上修改的代码文件，在提交commit时，会在githook中拦截进行检查，如果代码格式存在差异，会进行提示，可以复制提示的命令行`"xxxxxx/.spacecommand"/format-objc-files.sh -s`，在命令行中运行进行自动格式化

![commit check](https://tva1.sinaimg.cn/large/007S8ZIlly1geqx4rkrdtj312i0mrtg8.jpg)

或者在命令行中进行commit操作，此时会提示是否需要进行自动格式化，输入y/n进行选择，当需要格式化时，输入y则会进行自动格式化，如果所提交的代码经过自动格式化后出错，需要绕过precommit hook，可通过`git commit --no-verify`绕过钩子，或者在SourceTree中选择提交选项，绕过钩子

![command line](https://tva1.sinaimg.cn/large/007S8ZIlly1geqx95ig9qj30it061q3u.jpg)

选择自动格式化后，会对当前产生了变更的文件进行自动格式化操作，对应效果如下：
![after formate](https://tva1.sinaimg.cn/large/007S8ZIlly1geqxa90edoj30l0072abe.jpg)

SourceTree提交绕过钩子选择

![ignore hook](https://tva1.sinaimg.cn/large/007S8ZIlly1geqxxtg599j30ly05lwfv.jpg)

以下是经过代码自动格式化后，最终commit的代码内容产生的变更，会发现if后的括号换行进行了格式化操作，同时对于方法间的换行行数也进行了统一，方法间是统一的两行换行

![after formate](https://tva1.sinaimg.cn/large/007S8ZIlly1geqxbb5vlaj312q0dw76f.jpg)

以下是未格式化前对比的文件变更对比：

![precommit](https://tva1.sinaimg.cn/large/007S8ZIlly1geqx2c9tpfj31270jctav.jpg)