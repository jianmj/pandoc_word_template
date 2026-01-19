> 大多数 Markdown 笔记应用程序使用 Pandoc 将笔记转换为 Word 文档，例如我主要使用的思源笔记。然而，Pandoc 默认导出的 Word 文档样式往往不美观，不符合中文排版习惯。
>
> 幸运的是，pandoc 可以自定义 Word 模板，用于导出时的自动格式化以美化文档，但是很奇怪的是，全网很少有人分享自己是如何具体制作模板的，就算提到也只是泛泛而谈。我自己在制作模板中遇到很多问题，比如怎么设置表格样式、怎么设置列表样式。这里分享下目前在用的 word 模板，也当做一个抛砖引用，希望有更多人能分享自己的模板！😁

## 前排提示

- 本模板仅在Windows端的Office Word进行测试，可能不适合**WPS**和**苹果端的Office**。
- 自己使用时可以把模板文件内容清空，以减小导出word的文件大小。


## 样式预览

pandoc 不设置模板导出 docx 的样式

![](https://fastly.jsdelivr.net/gh/Achuan-2/PicBed/assets/20260119195423-2026-01-19.png)

设置本模板导出 docx 的样式

![](https://fastly.jsdelivr.net/gh/Achuan-2/PicBed/assets/20260119194848-2026-01-19.png)


## 模板介绍

- 标题编号 or 不编号
- 列表第二行缩进 or 列表第二行顶格
    - 列表第二行缩进
        ![1705299592624Snipaste_2024-01-15_14-19-46.png](https://fastly.jsdelivr.net/gh/Achuan-2/PicBed@pic/assets/1705299592624Snipaste_2024-01-15_14-19-46.png)
    - 列表第二行顶格效果
        ![1705299404618Snipaste_2024-01-15_14-16-34.png](https://fastly.jsdelivr.net/gh/Achuan-2/PicBed@pic/assets/1705299404618Snipaste_2024-01-15_14-16-34.png)
- sci论文模板：使用引述块作为Figure图注样式



## 如何使用此模板

pandoc通过 `--reference-doc `参数设置模板路径的，可以用命令行调用下面命令：

```bash
pandoc input.md --reference-doc template.docx -o output.docx
```

不过，pandoc在处理markdown转docx中存在以下问题
- 问题：不支持解析markdown中的html标签，比如`<sub>`、`<sup>`、`<img>`·等
  - 解决方案1：可以使用lua过滤器来解决这个问题，使用本repo的`lua/markdown-html-recognition.lua`文件
  - 解决方案2：先转html再转docx
- 问题：pandoc默认的图片标题是alt文本，我习惯是用title文本而不是alt文本作为图片标题（这也是思源笔记、语雀等笔记软件的语法解析规则）
  - 解决方案：使用本repo的`lua/image-title-to-caption.lua`文件
- 问题：markdown设置了字体颜色，比如`<span style="color:red">红色文字</span>`，但是导出时颜色丢失
  - 解决方案：使用本repo的`lua/add_font_color.lua`文件
- 问题：图片编号无法自定义
  - 解决方案：使用本repo 的`lua/image-title-to-caption-add-number.lua`

本repo提供了一个lua过滤器合集markdown-to-docx.lua，可以根据需要选用lua，这样可以让导出的docx文件更符合自己的需求：

```bash
pandoc input.md -t html | pandoc -f html -o output.docx --reference-doc template.docx --lua-filter markdown-to-docx.lua
```

我的pandoc使用博客：

  - [pandoc 导出docx如何对图表进行编号](https://zhuanlan.zhihu.com/p/1996674548762944192)
  - [pandoc将markdown导出为docx，如何修改图片标题为title文本而不是alt文本](https://zhuanlan.zhihu.com/p/1947343878836459221)
  - [pandoc 导出markdown为word不支持html标签](https://zhuanlan.zhihu.com/p/1947342033103623722)
  - [pandoc 将Markdown／Html导出为Docx，如何保留字体颜色](https://zhuanlan.zhihu.com/p/1996639589587231070)

## pandoc的其他问题记录


### 设置了代码块高亮样式，却发现导出的docx文件代码块高亮样式无法修改？
当使用`--highlight-style xxx`参数导出时，代码块的高亮样式会根据 `xxx` 的值来决定。pandoc 支持多种高亮样式，如 `pygments`、`breezeDark`、`tango`、`zenburn` 等。

但是如果你用markdown转docx得到的文件再作为模板的话，docx文件会有带有-Tok结尾的样式，导致代码块高亮样式无法修改。所以请直接使用本repo的docx文件作为模板。

pandoc 相关issue：[When pandoc sets a Word template, it cannot set highlight-style · Issue #10896 · jgm/pandoc](https://github.com/jgm/pandoc/issues/10896)

## 如何修改docx模板

注意，要修改模板，需要更改每个类型对应的Word的样式，而不是只是自己改改当前内容的样式就能work的。

### 一般样式

一般样式，只需要打开word的样式面板，鼠标点击改行，自动显示对应的样式，然后点击【修改】根据自己的需求修改样式就可以了

一般样式如下：

|        样式名        |         描述         |                                       默认样式                                        |
| :------------------: | :------------------: | :-----------------------------------------------------------------------------------: |
|       正文文本       |   在正文段落中应用   |          首行缩进，<br />字号小四，中文字体为宋体，英文Times New Roman<br />          |
|   First Paragraph    |       段落首段       |          首行缩进，<br />字号小四，中文字体为宋体，英文Times New Roman<br />          |
|       Compact        | 表格单元格、列表样式 |                      字号10，中文字体为宋体，英文Times New Roman                      |
|  Heading 1（标题1）  |       一级标题       | 字号小二，加粗，中文字体为黑体，英文Times New Roman，<br />段前24 磅，段后24 磅<br /> |
|  Heading 2（标题2）  |       二级标题       |                  字号三号，加粗，中文字体为黑体，英文Times New Roman                  |
|  Heading 3（标题3）  |       三级标题       |                   字号13，加粗，中文字体为黑体，英文Times New Roman                   |
|  Heading 4（标题4）  |       四级标题       |                     字号小四，中文字体为黑体，英文Times New Roman                     |
|  Heading 5（标题5）  |       五级标题       |                     字号小四，中文字体为黑体，英文Times New Roman                     |
|  Heading 6（标题6）  |       六级标题       |                     字号小四，中文字体为黑体，英文Times New Roman                     |
| Block Text（文本块） |      引述块样式      |                         四周添加1磅边框，左侧设置为6磅粗边框                          |
|     Source Code      | 行内代码和代码块样式 |                                    四周添加1磅边框                                    |

修改表格样式和列表样式比较特殊

### 表格样式

修改表格需要点击表格后，在【表设计】下拉，点击【修改表格样式】，进行修改

​![image](https://raw.githubusercontent.com/Achuan-2/PicBed/pic/assets/202312150014846.png)​

### 列表样式

#### 修改列表层级样式

> 所谓的层级样式是无序列表不同层级是圆点还是方块，有序列表则是不同层级的编号格式。

在下图①的位置点击，可以看到列表样式有两个样式，分别对应无序列表和有序列表样式，右键修改。

​![image](https://raw.githubusercontent.com/Achuan-2/PicBed/pic/assets/202312150014078.png)​

​![image](https://raw.githubusercontent.com/Achuan-2/PicBed/pic/assets/202312150014745.png)​

#### 修改列表缩进

鼠标点击列表所在行，右键点击【调整列表缩进】，选择【设置所有级别】

​![image](https://raw.githubusercontent.com/Achuan-2/PicBed/pic/assets/202312150014510.png)​



### 代码块高亮样式

当使用--highlight-style xxx参数导出时，代码块的高亮样式会根据 xxx 的值来决定。pandoc 支持多种高亮样式，如 pygments、breezeDark、tango、zenburn 等。
具体见[pandoc_highlight](https://github.com/kaityo256/pandoc_highlight).

如果发现代码块高亮样式无法修改，可能是因为word模板的样式包含代码高亮样式，导致无法修改。可以尝试删除模板中的代码高亮样式（Source Code以及所有Tok结尾的样式），然后重新导出。

![1749176940350PixPin_2025-06-06_10-28-00.png](https://fastly.jsdelivr.net/gh/Achuan-2/PicBed@pic/assets/1749176940350PixPin_2025-06-06_10-28-00.png)

## 模板已知问题

1. 如果使用WPS打开基于模板导出的文档，可能存在兼容性问题，建议还是用Office Word打开
2. 图片无法自动居中，另外注意图片添加题注要居中的话，必须先让图片居中，再添加题注。
3. 模板可以做到表格整体居中，但是表格单元格自动居中需要思源笔记文档中的表格本身先设置居中，否则不居中。这是因为markdown表格默认是居左的，markdown的居中语法如下：

    ```markdown
    | header 1 | header 2 |
    | :------: | :------: |
    |  cell 1  |  cell 2  |
    |  cell 3  |  cell 4  |
    |  cell 5  |  cell 6  |
    ```

## 我的探索过程记录

1. 有序列表和无序列表可以基于模板改动项目符号，老实说这是我误打误撞搞出来的😂……目前自己都没能复现，所以大家不想折腾，还是基于本模板改动，且用且珍惜（如果有知道怎么复现的，欢迎指教🙏）。
2. 有序列表和无序列表的行间距调整：每个列表项的间距与【正文】样式的行间距有关，此外列表项的子文本段落也是正文样式而不是【正文文本样式】（一般段落其实是【First Paragraph】、【正文文本】样式），所以需要调整列表行间距而改动【正文】样式是不太影响正文的（不过需要注意【First Paragraph】、【正文文本】样式都是基于【正文】样式改动的。为了让列表更美观，我把【正文】样式设置为1.5倍行距，不设置段前和段后距离，【First Paragraph】、【正文文本】会设置段前和段后距离

## 📒博客

- [全网找不到满意的 Markdown 转 Docx 模板，那就自己动手吧](https://zhuanlan.zhihu.com/p/672376543)
- [设置word模板，Markdown 也能自动转换为美观规范的 Word 文档](https://zhuanlan.zhihu.com/p/581000852)
- [pandoc 导出markdown为word不支持html标签](https://zhuanlan.zhihu.com/p/1947342033103623722)
- [pandoc将markdown导出为docx，如何修改图片标题为title文本而不是alt文本](https://zhuanlan.zhihu.com/p/1947343878836459221)
- [科研写作之Docx格式（Word）与Markdown如何互转](https://zhuanlan.zhihu.com/p/1984680822465376921)


## ❤Donate

如果这个项目对你有帮助，欢迎给我打赏！

<img src="https://cdn.nlark.com/yuque/0/2024/jpeg/1408046/1714754573393-9c7f70b0-05ec-489e-b5a2-1a37fb681f6f.jpeg?x-oss-process=image%2Fformat%2Cwebp%2Finterlace%2C1" width="50%" >
