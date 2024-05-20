%%
%%  Copyright (C) 2024--2024 mslxl<i@mslxl.com> & SDUFEACM <https://github.com/sdufeacm>
%% 
%%  This work may be distributed and/or modified under the
%%  conditions of the LaTeX Project Public License, either
%%  version 1.3c of this license or (at your option) any later
%%  version. The latest version of this license is in:
%% 
%%    http://www.latex-project.org/lppl.txt
%% 
%%  and version 1.3 or later is part of all distributions of
%%  LaTeX version 2008 or later.
%% 
%%  This work has the LPPL maintenance status `maintained'.
%% 
%%  The Current Maintainer of this work is Mslxl <i@mslxl.com>.
%%
%%  This work is modified from WHU-thesis and Fudan-thesis, thanks for their great work
%%  Contact mslxl or current acm club leader for more infomation
%%

%tag 标识节
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass {sdufe-thesis} {2024-03-27} {v0.0.1}
  {Thesis template for Shandong University of Finance and Economics}

%tag 简化-msg-模块的函数
\cs_new:Npn \__sdufe_msg_new:nn  { \msg_new:nnn      { sdufe-thesis } }
\cs_new:Npn \__sdufe_warning:nn  { \msg_warning:nnn  { sdufe-thesis } }
\cs_new:Npn \__sdufe_error:n     { \msg_error:nn     { sdufe-thesis } }
\cs_new:Npn \__sdufe_error:nn    { \msg_error:nnn    { sdufe-thesis } }
\cs_new:Npn \__sdufe_fatal:nx    { \msg_fatal:nnx    { sdufe-thesis } }

\cs_if_exist:NF \NewDocumentCommand
  { \RequirePackage { xparse } }
\RequirePackage { xtemplate, l3keys2e }

\__sdufe_msg_new:nn { l3-too-old }
  {
    Package~ "#1"~ is~ too~ old. \\\\
    Please~ update~ an~ up-to-date~ version~ of~ the~ bundles \\
    "l3kernel"~ and~ "l3packages"~ using~ your~ TeX~ package \\
    manager~ or~ from~ CTAN.
  }
\clist_map_inline:nn { expl3, xtemplate, l3keys2e }
  {
    \@ifpackagelater {#1} { 2018/05/12 }
      { } { \__sdufe_error:nn { l3-too-old } {#1} }
  }
\sys_if_engine_xetex:F
  {
    \sys_if_engine_luatex:F
      {
        \__sdufe_fatal:nx { unsupported-engine }
          { \c_sys_engine_str }
      }
  }
\__sdufe_msg_new:nn { unsupported-engine }
  {
    The~ sdufe-thesis~ class~ requires~ either~ XeTeX~ or~ LuaTeX. \\\\
    "#1"~ is~ not~ supported~ at~ present.~ You~ must~ change \\
    your~ typesetting~ engine~ to~ "xelatex"~ or~ "lualatex".
  }

%tag 用户设置命令接口
\NewDocumentCommand \sdufesetup { m }
  { \keys_set:nn { sdufe } {#1} }

%tag meta-key
\keys_define:nn { sdufe }
  {
    style .meta:nn = { sdufe / style } {#1},
    info  .meta:nn = { sdufe / info  } {#1}
  }

%tag 定义全局变量
\clist_new:N \g__sdufe_to_ctexbook_clist   % 储存通过文档类选项传递给 ctexbook 的选项
\bool_new:N \g__sdufe_draft_bool
\bool_new:N \g__sdufe_twoside_bool

%tag 临时变量
\box_new:N \l__sdufe_tmpa_box
\box_new:N \l__sdufe_tmpb_box
\clist_new:N \l__sdufe_tmpa_clist
\clist_new:N \l__sdufe_tmpb_clist
\tl_new:N \l__sdufe_tmpa_tl
\tl_new:N \l__sdufe_tmpb_tl
\dim_new:N \l__sdufe_tmpa_dim
\dim_new:N \l__sdufe_tmpb_dim
\dim_new:N \l__sdufe_tmpc_dim


\hook_gset_rule:nnnn { begindocument/before } { . } { < } { xeCJK }


%tag 函数变体
\prg_generate_conditional_variant:Nnn \int_case:nn { Vn , xn } { T, F, TF }
\cs_generate_variant:Nn \int_case:nn { Vn, xn }
\cs_generate_variant:Nn \tl_map_inline:nn { xn }
\cs_generate_variant:Nn \dim_set:Nn { Nx }
\cs_generate_variant:Nn \str_case:nn { xn }

%region 基本函数

%tag 空白页
\cs_new:Npn \__sdufe_new_blank_page:
  {
    \newpage \null \thispagestyle{empty} \newpage
  }

%tag 分割线
\cs_new_protected:Npn \__sdufe_hrule:
  {
      \noindent
    \mode_leave_vertical:
    \rule{\linewidth}{0.5mm}
  }

\cs_new_protected:Npn \__sdufe_hhrule:
  {
    \begin{spacing}{0.10}
      \noindent
      \rule{\linewidth}{0.4pt} \\
      \rule{\linewidth}{0.4pt} \\
    \end{spacing}
  }


%tag 分散盒子
\cs_new_protected:Npn \__sdufe_spread_box:nn #1#2
  % #1: 宽度
  % #2: 内容
  {
    \mode_leave_vertical:
    \hbox_to_wd:nn {#1}
      { \tl_map_inline:xn {#2} { ##1 \hfil } \unskip }
  }
\cs_new_protected:Npn \__sdufe_spread_box_with_end_spaces:nn #1#2
  {
    \mode_leave_vertical:
    \hbox_to_wd:nn {#1}
      { \hspace{0.19cm} \tl_map_inline:xn {#2} { ##1 \hfil } \unskip \hspace{0.19cm}}
  }


%tag 分隔盒子
\cs_new_protected:Npn \__sdufe_spread_box_with_separator:nn #1#2
  % #1: 分隔内容
  % #2: 内容
  {
    \mode_leave_vertical:
    \hbox_set:Nn \l__sdufe_tmpa_box
      { \tl_map_inline:xn {#2} { ##1 #1 } \unskip }
    \box_use_drop:N \l__sdufe_tmpa_box
  }
\cs_generate_variant:Nn \__sdufe_spread_box_with_separator:nn { nv }
\cs_new_protected:Npn \__sdufe_spread_box_with_quad:n #1
  {
    \__sdufe_spread_box_with_separator:nn { \quad } {#1}
  }

%tag 获取宽度与-clist-的内容的最大宽度
\cs_new:Npn \__sdufe_get_text_width:Nn #1#2
  {
    \hbox_set:Nn \l__sdufe_tmpa_box {#2}
    \dim_set:Nn #1 { \box_wd:N \l__sdufe_tmpa_box }
  }
\cs_generate_variant:Nn \__sdufe_get_text_width:Nn { NV }
\cs_new:Npn \__sdufe_get_max_text_width:NN #1#2
  {
    \group_begin:
      \clist_set_eq:NN \l__sdufe_tmpa_clist #2
      \bool_until_do:nn { \clist_if_empty_p:N \l__sdufe_tmpa_clist }
        {
          \clist_pop:NN \l__sdufe_tmpa_clist \l__sdufe_tmpa_tl
          \__sdufe_get_text_width:NV \l__sdufe_tmpa_dim \l__sdufe_tmpa_tl
          \dim_gset:Nn #1 { \dim_max:nn {#1} { \l__sdufe_tmpa_dim } }
        }
    \group_end:
  }

%tag 删除章标题中的-\quad
\cs_new_protected:Npn \__sdufe_sanitize_chapter_title:n #1
  {
    \tl_clear:N \l__sdufe_tmpa_tl
    \tl_set:No \l__sdufe_tmpa_tl {#1}
    \tl_remove_all:Nn \l__sdufe_tmpa_tl { \quad }
  }
%tag 手动生成章的标题，用于摘要、参考文献等
\cs_new_protected:Npn \__sdufe_chapter:n #1
  {
    \__sdufe_sanitize_chapter_title:n {#1}
    \group_begin:
      \ctexset { chapter / numbering = false }
      \chapter [ \l__sdufe_tmpa_tl ] {#1}
    \group_end:
    \__sdufe_chapter_header:n {#1}
  }
\cs_generate_variant:Nn \__sdufe_chapter:n { V }
\cs_new_protected:Npn \__sdufe_chapter_header:n #1
  {
    \bool_if:NTF \g__sdufe_twoside_bool
      { \markboth {#1} {#1} }
      { \markboth { \hfill #1 \hfill } { } }
  }
%endregion 基本函数


%region 处理文档类的选项
%tag 选项定义
\keys_define:nn { sdufe / option }
  {
    oneside .value_forbidden:n = true,
    twoside .value_forbidden:n = true,
    oneside .code:n =
      {
        \clist_gput_right:Nn \g__sdufe_to_ctexbook_clist { oneside }
        \bool_set_false:N    \g__sdufe_twoside_bool
      },
    twoside .code:n =
      {
        \clist_gput_right:Nn \g__sdufe_to_ctexbook_clist { twoside }
        \bool_set_true:N     \g__sdufe_twoside_bool
      },
    
    openany .value_forbidden:n = true,
    openany .code:n =
      {
        \clist_gput_right:Nn \g__sdufe_to_ctexbook_clist { openany }
      },
    showframe .value_forbidden:n = true,
    showframe .code:n =
      {
        \PassOptionsToPackage { showframe } { geometry }
      },
    draft .choice:,
    draft / true  .code:n =
      {
        \bool_set_true:N     \g__sdufe_draft_bool
        \clist_gput_right:Nn \g__sdufe_to_ctexbook_clist { draft }
      },
    draft / false .code:n =
      { \bool_set_false:N    \g__sdufe_draft_bool },
    draft .default:n = true,
    draft .initial:n = false,
    unknown .code:n = { \__sdufe_error:n { unknown-option } }
  }
\__sdufe_msg_new:nn { unknown-option }
  { Class~ option~ "\l_keys_key_str"~ is~ unknown. }
\ProcessKeysOptions { sdufe / option }


%tag 行距

% 本科小四，23磅，1.5 倍行间距
\fp_const:Nn \c__sdufe_bachelor_line_spread_fp
  { \dim_ratio:nn { 23 pt } { 12 bp } / 1.5 }
\PassOptionsToClass { zihao = -4 , linespread = \c__sdufe_bachelor_line_spread_fp } { ctexbook }


%tag 页面的单双面设置
% 本科：默认 twoside
\PassOptionsToClass { twoside } { ctexbook }

\PassOptionsToClass
  {
    UTF8,
    heading  = true,
    \g__sdufe_to_ctexbook_clist,
    fontset = none
  }
  { ctexbook }
%endregion 处理文档类的选项


%tag 给预加载的宏包传递选项
\clist_map_inline:nn
  {
    { no-math  } { fontspec },
    { numbered } { bookmark },
    { titles   } { tocloft  },
    { perpage  } { footmisc }
  }
  { \PassOptionsToPackage #1 }

\RequirePackage { filehook }
% 消去 CJK 警告
\AtEndOfPackageFile* { fontspec }
  { \msg_redirect_name:nnn { fontspec } { no-script } { none } }
\AtEndOfPackageFile* { xeCJK }
  {
    \msg_redirect_name:nnn { xeCJK } { CJKfamily-redef } { none }
    \defaultCJKfontfeatures { Script  = CJK }   
  }

%tag 加载-ctexbook
\LoadClass { ctexbook }

%tag 加载宏包 (in alphabetic order)
\RequirePackage { amsmath }
\RequirePackage { amssymb }
\RequirePackage { amsthm }
\RequirePackage { bookmark }
\RequirePackage { booktabs }
\RequirePackage { caption }
\RequirePackage { enumitem }
\RequirePackage { etoolbox }
\RequirePackage { fancyhdr }
\RequirePackage { fixdif }
\RequirePackage { fontspec }
\RequirePackage { footmisc }
\RequirePackage { geometry }
\RequirePackage { graphicx }
\RequirePackage { setspace }
\RequirePackage { thmtools }
\RequirePackage { tikzpagenodes }
\RequirePackage { titlesec }
\RequirePackage { titletoc }
\RequirePackage { tocloft }
\RequirePackage { xeCJK }
\RequirePackage { xeCJKfntef }

\AtEndPreamble
  {
    \RequirePackage { hyperref }
  }



%region 页面尺寸设置 (paper size setting)
% 统一都是 A4 纸大小
\geometry{paper = a4paper}


\geometry
  {
    left       = 25mm,
    right      = 20mm,
    top        = 25mm,
    bottom     = 20mm,

    % Todo: 
    headheight = 3mm,
    headsep    = 2mm,
    footskip   = 6mm
  }

\ctex_after_end_preamble:n
  {
    \renewcommand{\cleardoublepage}{\clearpage}
  }

%region 字体配置 (font configuration)
%tag 预备函数
\cs_new_protected:Npn \__sdufe_set_cjk_main_font:nn #1#2
  {
    \setCJKmainfont{#1}[#2]
    \newCJKfontfamily [zhsong] \songti {#1} [#2]
  }
\cs_new_protected:Npn \__sdufe_set_cjk_sans_font:nn #1#2
  {
    \setCJKsansfont{#1}[#2]
    \newCJKfontfamily [zhhei] \heiti {#1} [#2]
  }
\cs_new_protected:Npn \__sdufe_set_cjk_mono_font:nn #1#2
  {
    \setCJKmonofont{#1}[#2]
    \newCJKfontfamily [zhfs] \fangsong {#1} [#2]
  }
\cs_new_protected:Npn \__sdufe_set_cjk_font_kaishu:nn #1#2
  {
    \newCJKfontfamily [zhkai] \kaishu {#1} [#2]
  }
\tl_const:Nn \l__sdufe_cjk_font_options_tl { UprightFont = *, ItalicFont = *, AutoFakeBold }
\cs_new_protected:Npx \__sdufe_set_cjk_main_font:n #1
  { \__sdufe_set_cjk_main_font:nn {#1} { \l__sdufe_cjk_font_options_tl } }
\cs_new_protected:Npx \__sdufe_set_cjk_sans_font:n #1
  { \__sdufe_set_cjk_sans_font:nn {#1} { \l__sdufe_cjk_font_options_tl } }
\cs_new_protected:Npx \__sdufe_set_cjk_mono_font:n #1
  { \__sdufe_set_cjk_mono_font:nn {#1} { \l__sdufe_cjk_font_options_tl } }
\cs_new_protected:Npx \__sdufe_set_cjk_font_kaishu:n #1
  { \__sdufe_set_cjk_font_kaishu:nn {#1} { \l__sdufe_cjk_font_options_tl } }

\bool_new:N \g__sdufe_style_cjk_fakefont_bool
\tl_new:N \g__sdufe_style_math_font_choice_tl
%tag 定义键
\keys_define:nn { sdufe / style }
  {
    font .choices:nn =
      { times, xits, termes, default }
      { \cs_gset_eq:Nc \__sdufe_style_font_use: { __sdufe_style_font_set_ \l_keys_choice_tl : } },
    font .value_required:n = true,
    math-font .choices:nn =
      { xits, termes, default }
      { 
        \cs_gset_eq:Nc \__sdufe_style_math_font_use: { __sdufe_style_math_font_set_ \l_keys_choice_tl : }
        \tl_gset_eq:NN \g__sdufe_style_math_font_choice_tl \l_keys_choice_tl
      },
    math-font .value_required:n = true,
    cjk-font .choices:nn =
      { windows, mac, fandol, sourcehan, founder, none }
      { \cs_gset_eq:Nc \__sdufe_style_cjk_font_use: { __sdufe_style_cjk_font_set_ \l_keys_choice_tl : } },
    cjk-font .value_required:n = true,
    cjk-fakefont .bool_set:N = \g__sdufe_style_cjk_fakefont_bool,
    cjk-fakefont .default:n = true
  }


%region 西文字体设置 (english font setting)
%tag times
\cs_new_protected:Npn \__sdufe_style_font_set_times:
  {
    \setmainfont { Times ~ New ~ Roman }
      [
        SmallCapsFont = { TeX ~ Gyre ~ Termes },
        SmallCapsFeatures = { Letters = SmallCaps }
      ]
  }
%tag xits
\cs_new_protected:Npn \__sdufe_style_font_set_xits:
  {
    \setmainfont { XITS } 
      [
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Italic,
        BoldItalicFont = *-BoldItalic
      ]
  }
%tag termes
\cs_new_protected:Npn \__sdufe_style_font_set_termes:
  {
    \setmainfont { texgyretermes }
      [
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic
      ]
  }
\cs_new_protected:Npn \__sdufe_style_font_set_default: { }
%endregion 西文字体设置

%tag 数学字体设置 (math font setting)
\cs_new_protected:Npn \__sdufe_style_math_font_set_xits:
  {
    \setmathfont { XITSMath-Regular.otf } 
      [ 
        BoldFont     = XITSMath-Bold.otf,
      ]
    \setmathfont { XITSMath-Regular.otf } 
      [
        range        = {cal, bfcal},
        StylisticSet = 01
      ]
  }
\cs_new_protected:Npn \__sdufe_style_math_font_set_termes:
  {
    \setmathfont { texgyretermes-math.otf }
  }
\cs_new_protected:Npn \__sdufe_style_math_font_set_default: { }


%region 中文字体设置 (chinese font setting)
%tag default
\cs_new_protected:Npn \__sdufe_style_cjk_font_set_none: { }
%tag windows
\cs_new_protected:Npn \__sdufe_style_cjk_font_set_windows:
  {
    \bool_if:NTF \g__sdufe_style_cjk_fakefont_bool
      {
        \__sdufe_set_cjk_main_font:nn { SimSun }
          { AutoFakeBold = 4, AutoFakeSlant = 0.167 }
        \__sdufe_set_cjk_sans_font:nn { SimHei }
          { AutoFakeBold = 4, AutoFakeSlant = 0.167 }
        \__sdufe_set_cjk_mono_font:nn { FangSong }
          { AutoFakeBold = 4, AutoFakeSlant = 0.167 }
        \__sdufe_set_cjk_font_kaishu:nn { KaiTi }
          { AutoFakeBold = 4, AutoFakeSlant = 0.167 }
      }
      {
        \__sdufe_set_cjk_main_font:nn { SimSun }
          { 
            BoldFont       = SimHei,
            ItalicFont     = KaiTi,
            SlantedFont    = KaiTi,
            BoldItalicFont = SimHei
          }
        \__sdufe_set_cjk_sans_font:nn { SimHei }
          { BoldFont = *, ItalicFont = *, SlantedFont = *, BoldItalicFont = * }
        \__sdufe_set_cjk_mono_font:nn { FangSong }
          { BoldFont = *, ItalicFont = *, SlantedFont = *, BoldItalicFont = * }
        \__sdufe_set_cjk_font_kaishu:nn { KaiTi }
          { BoldFont = *, ItalicFont = *, SlantedFont = *, BoldItalicFont = * }
      }
  }
%tag mac
\cs_new_protected:Npn \__sdufe_style_cjk_font_set_mac:
  {
    \bool_if:NTF \g__sdufe_style_cjk_fakefont_bool
      {
        \__sdufe_set_cjk_main_font:nn { Songti~ SC~ Light }
          {
            BoldFont       = Songti~ SC~ Bold,
            AutoFakeSlant  = 0.167
          }
        \__sdufe_set_cjk_sans_font:nn { Heiti~ SC~ Light }
          {
            BoldFont      = Heiti~ SC~ Medium,
            AutoFakeSlant = 0.167
          }
        \__sdufe_set_cjk_mono_font:nn { STFangsong }
          { AutoFakeBold = 4, AutoFakeSlant = 0.167 }
        \__sdufe_set_cjk_font_kaishu:nn { Kaiti~ SC~ Regular }
          { 
            BoldFont      = Kaiti~ SC~ Bold, 
            AutoFakeSlant = 0.167
          }
      }
      {
        \__sdufe_set_cjk_main_font:nn { Songti~ SC~ Light }
          {
            BoldFont       = Songti~ SC~ Bold,
            ItalicFont     = Kaiti~ SC~ Regular,
            SlantedFont    = Kaiti~ SC~ Regular,
            BoldItalicFont = Songti~ SC~ Bold
          }
        \__sdufe_set_cjk_sans_font:nn { Heiti~ SC~ Light }
          {
            BoldFont       = Heiti~ SC~ Medium,
            ItalicFont     = *,
            SlantedFont    = *,
            BoldItalicFont = Heiti~ SC~ Medium
          }
        \__sdufe_set_cjk_mono_font:nn { STFangsong }
          { BoldFont = *, ItalicFont = *, SlantedFont = *, BoldItalicFont = * }
        \__sdufe_set_cjk_font_kaishu:nn { Kaiti~ SC~ Regular }
          { 
            BoldFont       = Kaiti~ SC~ Bold, 
            ItalicFont     = *, 
            SlantedFont    x *, 
            BoldItalicFont = Kaiti~ SC~ Bold
          }
      }
  }
%tag fandol
\cs_new_protected:Npn \__sdufe_style_cjk_font_set_fandol:
  {
    \bool_if:NTF \g__sdufe_style_cjk_fakefont_bool
      {
        \__sdufe_set_cjk_main_font:nn { FandolSong-Regular.otf }
          {
            BoldFont      = FandolSong-Bold.otf,
            AutoFakeSlant = 0.167
          }
        \__sdufe_set_cjk_sans_font:nn { FandolHei-Regular.otf }
          {
            BoldFont      = FandolHei-Bold.otf,
            AutoFakeSlant = 0.167
          }
        \__sdufe_set_cjk_mono_font:nn { FandolFang-Regular.otf }
          { AutoFakeBold = 4, AutoFakeSlant = 0.167 }
        \__sdufe_set_cjk_font_kaishu:nn { FandolKai-Regular.otf }
          { AutoFakeBold = 4, AutoFakeSlant = 0.167 }
      }
      {
        \__sdufe_set_cjk_main_font:nn { FandolSong-Regular.otf }
          {
            BoldFont       = FandolSong-Bold.otf,
            ItalicFont     = FandolKai-Regular.otf,
            SlantedFont    = FandolKai-Regular.otf,
            BoldItalicFont = FandolSong-Bold.otf
          }
        \__sdufe_set_cjk_sans_font:nn { FandolHei-Regular.otf }
          {
            BoldFont       = FandolHei-Bold.otf,
            ItalicFont     = *,
            SlantedFont    = *,
            BoldItalicFont = FandolHei-Bold.otf
          }
        \__sdufe_set_cjk_mono_font:nn { FandolFang-Regular.otf }
          { BoldFont = *, ItalicFont = *, SlantedFont = *, BoldItalicFont = * }
        \__sdufe_set_cjk_font_kaishu:nn { FandolKai-Regular.otf }
          { BoldFont = *, ItalicFont = *, SlantedFont = *, BoldItalicFont = * }
      }
  }
%tag founder
\cs_new_protected:Npn \__sdufe_style_cjk_font_set_founder:
  {
    \__sdufe_set_cjk_main_font:nn  { FZShuSong-Z01  } { BoldFont = FZHei-B01, ItalicFont = FZKai-Z03 }
    \__sdufe_set_cjk_sans_font:n   { FZHei-B01      }
    \__sdufe_set_cjk_mono_font:n   { FZFangSong-Z02 }
    \__sdufe_set_cjk_font_kaishu:n { FZKai-Z03      }
  }
%tag source-han
\cs_new_protected:Npn \__sdufe_style_cjk_font_set_sourcehan:
  {
    \bool_if:NTF \g__sdufe_style_cjk_fakefont_bool
      {
        \__sdufe_set_cjk_main_font:nn { Source~ Han~ Serif~ SC }
          {
            UprightFont   = *-Regular,
            BoldFont      = *-Bold,
            AutoFakeSlant = 0.167
          }
        \__sdufe_set_cjk_sans_font:nn { Source~ Han~ Sans~ SC }
          {
            UprightFont   = *-Regular,
            BoldFont      = *-Bold,
            AutoFakeSlant = 0.167
          }
        \__sdufe_set_cjk_font_kaishu:nn { FZKai-Z03 }
          { AutoFakeBold = 4, AutoFakeSlant = 0.167 }
        \__sdufe_set_cjk_mono_font:nn { FZFangSong-Z02 } 
          { AutoFakeBold = 4, AutoFakeSlant = 0.167 }
      }
      {
        \__sdufe_set_cjk_main_font:nn { Source~ Han~ Serif~ SC }
          {
            UprightFont    = *-Regular,
            BoldFont       = *-Bold,
            ItalicFont     = *-Regular,
            BoldItalicFont = *-Bold
          }
        \__sdufe_set_cjk_sans_font:nn { Source~ Han~ Sans~ SC }
          {
            UprightFont    = *-Regular,
            BoldFont       = *-Bold,
            ItalicFont     = *-Regular,
            BoldItalicFont = *-Bold
          }
        \__sdufe_set_cjk_font_kaishu:nn { FZKai-Z03 }
          {
            BoldFont       = *,
            ItalicFont     = *,
            BoldItalicFont = *
          }
        \__sdufe_set_cjk_mono_font:nn { FZFangSong-Z02 } 
          {
            BoldFont       = *,
            ItalicFont     = *,
            BoldItalicFont = *
          }
      }
  }
%endregion 中文字体设置
%tag 使用字体 (use font)
\AtEndPreamble
  {
    \tl_if_eq:NnTF \g__sdufe_style_math_font_choice_tl {default}
      {
        \RequirePackage{mathrsfs}
        \DeclareFontFamily{U}{rsfs}{\skewchar\font127 }
        \DeclareFontShape{U}{rsfs}{m}{n}{
          <5-6> rsfs5
          <6-8> rsfs7
          <8-> rsfs10
        }{}
      }
      {
        \RequirePackage [ bold-style = ISO ] { unicode-math }
      }
    \__sdufe_style_font_use:
    \__sdufe_style_math_font_use:
    \__sdufe_style_cjk_font_use:
  }
%tag 设置默认字体
\keys_set:nn { sdufe / style }
  {
    font         = times,
    math-font    = termes,
    cjk-font     = fandol,
    cjk-fakefont = false,
  }
%endregion 字体配置

%region 章节标题设置与列表设置

\setlist{nosep}

\titleformat{\chapter}{\centering\zihao{3}\bfseries}{第\,\thechapter\,章}{1em}{}

\keys_set:nn { ctex }
  {
    % 编号到 subsubsection
    secnumdepth = 3,
    chapter = 
      {
        format       = \zihao{-2}\sffamily\centering,
        number       = \arabic{chapter},
        numberformat = \rmfamily,
        name         = {},
        beforeskip   = 0.8 \baselineskip,
        afterskip    = 0.5 \baselineskip,
        fixskip      = true,
        pagestyle    = bachelor-mainmatter
      },
    section = 
      {
        format       = \zihao{4}\sffamily,
        numberformat = \rmfamily,
        beforeskip   = 0.5 \baselineskip,
        afterskip    = 0.5 \baselineskip,
        fixskip      = true,
      },
    subsection = 
      {
        format       = \zihao{-4}\sffamily,
        numberformat = \rmfamily,
        beforeskip   = 0.5 \baselineskip,
        afterskip    = 0.5 \baselineskip,
        fixskip      = true,
      },
    subsubsection = 
      {
        format       = \zihao{-4}\sffamily,
        numberformat = \rmfamily,
        beforeskip   = 0.5 \baselineskip,
        afterskip    = 0.5 \baselineskip,
        fixskip      = true,
      },
}

% enumerate
\setenumerate[1]
  {
    labelindent    = \parindent,
    leftmargin     = 0pt,
    widest         = 0,
    itemindent     = *,
    listparindent  = \parindent,
    label          = (\arabic*)
  }
\setenumerate[2]
  {
    labelindent    = \parindent,
    leftmargin     = 4em,
    itemindent     = 13pt,
    listparindent  = \parindent,
    label          = \circlednumber{\arabic*}
  }
%endregion

%region 页眉页脚样式
%tag 本科
\fancypagestyle { bachelor-frontmatter }
  {
    \fancyhf { }
    \fancyfoot[C] { \zihao{5} \arabic{page} }
    \renewcommand \headrulewidth { 0pt } 
  }
\fancypagestyle { bachelor-mainmatter }
  {
    \fancyhf { }
    \fancyfoot[C] { \zihao{5} \arabic{page} }
    \fancyhead[C] { \zihao{5} \__sdufe_spread_box:nn {8cm} {山东财经大学本科毕业论文（设计）}}
    \renewcommand \headrulewidth { 0.5pt } 
    \setlength{\headheight}{13pt}
  }
%tag 给-\mainmatter-添加钩子
\AddToHook{ cmd / mainmatter / after }
  { \exp_args:No \pagestyle { bachelor-mainmatter } }
%endregion


%region 个人信息
%tag 定义键
\keys_define:nn { sdufe / info }
  {
    title           .tl_set:N = \l__sdufe_info_title_tl,
    title*          .tl_set:N = \l__sdufe_info_title_en_tl,
    department      .tl_set:N = \l__sdufe_info_department_tl,
    major           .tl_set:N = \l__sdufe_info_major_tl,
    class           .tl_set:N = \l__sdufe_info_class_tl,
    student-id      .tl_set:N = \l__sdufe_info_student_id_tl,
    author          .tl_set:N = \l__sdufe_info_author_tl,
    supervisor      .tl_set:N = \l__sdufe_info_supervisor_tl,
    year           .int_set:N = \l__sdufe_info_year_int,
    month          .int_set:N = \l__sdufe_info_month_int,
    keywords     .clist_set:N = \l__sdufe_info_keywords_clist,
    keywords*    .clist_set:N = \l__sdufe_info_keywords_en_clist,
  }
%tag 初始化公共键
\keys_set:nn { sdufe / info }
  {
    year = \c_sys_year_int,
    month = \c_sys_month_int,
    keywords = {\LaTeX{}, 毕业论文, 模版, 山东财经大学},
    keywords* = {\LaTeX{}, Thesis, Template, Shandong~University~of~Finance~and~Economics},
    student-id = xxxxxxxxxxx
  }

%tag 函数，用于定义常量
% 只定义中文
\cs_new_protected:Npn \__sdufe_define_name:nn #1#2
  { \tl_const:cn { c__sdufe_name_ #1 _tl } {#2} }
% 中英文（或中文+拼音）
\cs_new_protected:Npn \__sdufe_define_name:nnn #1#2#3
  {
    \tl_const:cn { c__sdufe_name_ #1    _tl } {#2}
    \tl_const:cn { c__sdufe_name_ #1 _en_tl } {#3}
  }

\clist_map_inline:nn
  {
    { student_id } { 学号 },
    { toc } { 目 \hspace{2em} 录 },
    { type } { 本科毕业论文（设计） },
    { department } { 学院 },
    { major } { 专业 },
    { class } { 班级 },
    { author } { 姓名 },
    { supervisor } { 指导教师 },
  }
  { \__sdufe_define_name:nn #1 }

\clist_map_inline:nn
  {
    { keywords } { 关键词 } { Keywords },
    { abstract } { 摘 \hspace{2em} 要 } { ABSTRACT },
  }
  { \__sdufe_define_name:nnn #1 }

\keys_set:nn { sdufe / info }
  {
    title       = {山东财经大学本科生毕业论文 \LaTeX{} 模版},
    department  = {计算机科学与技术学院},
    major       = {计算机科学与技术},
    class       = {计算机科学与技术 114514 班},
    student-id  = {2021202012345},
    author      = {张三},
    supervisor  = {李某某教授},
  }
%endregion 个人信息


%region 封面
\cs_new_protected:Npn \__sdufe_bachelor_cover_i:
  {
    \newgeometry { hmargin = 2.445 cm , vmargin = 2.54cm }
    % logo and type
    \__sdufe_bachelor_cover_i_logo_and_type:
    % 论文标题
    \__sdufe_bachelor_cover_i_title:
    % 个人信息
    \__sdufe_bachelor_cover_i_information:
    % 时间
    \__sdufe_bachelor_cover_i_date_zh:
    \restoregeometry
  }

% %tag logo-and-type
\cs_new_protected:Npn \__sdufe_bachelor_cover_i_logo_and_type:
  {
    \mode_leave_vertical:
    \skip_vertical:n { 2.01 cm }
    \noindent
    \begin{minipage}[t][3.85cm]{\textwidth}
      \centering
      \includegraphics[ width = 93.01mm, height=19.28mm ]{ logo / sdufe.png }
      \skip_vertical:n { 0.46 cm }
      \fangsong \zihao{0} \bfseries \c__sdufe_name_type_tl
    \end{minipage}\par
  }

% %tag 论文标题
\cs_new_protected:Npn \__sdufe_bachelor_cover_i_title:
  {
    \skip_vertical:n { 2.62cm }
    \noindent
    \begin{minipage}[t][5.01cm]{\textwidth}
      \skip_vertical:n { 0.5cm }
      \centering \zihao{-1} \heiti \bfseries
      \l__sdufe_info_title_tl
    \end{minipage}\par
  }

% %tag 个人信息
\cs_new_protected:Npn \__sdufe_bachelor_cover_i_information:
  {
    \clist_set:Nx \l__sdufe_tmpa_clist
      {
        \c__sdufe_name_department_tl,
        \c__sdufe_name_major_tl,
        \c__sdufe_name_class_tl,
        \c__sdufe_name_author_tl,
        \c__sdufe_name_student_id_tl,
        \c__sdufe_name_supervisor_tl
      }
    \clist_set:Nx \l__sdufe_tmpb_clist
      {
        \l__sdufe_info_department_tl,
        \l__sdufe_info_major_tl,
        \l__sdufe_info_class_tl,
        \l__sdufe_info_author_tl,
        \l__sdufe_info_student_id_tl,
        \l__sdufe_info_supervisor_tl
      }
    \noindent
    \begin{minipage}[t][4.5cm]{\textwidth}
      \fangsong \zihao{4}
      \skip_vertical:n { 0.26cm }
      \bool_until_do:nn
        { \clist_if_empty_p:N \l__sdufe_tmpa_clist }
        {
          \clist_pop:NN \l__sdufe_tmpa_clist \l__sdufe_tmpa_tl
          \clist_pop:NN \l__sdufe_tmpb_clist \l__sdufe_tmpb_tl
          \__sdufe_get_text_width:NV \l__sdufe_tmpa_dim \l__sdufe_tmpb_tl

          \hspace*{3.65cm}
          \__sdufe_spread_box:nn { 4em } { \l__sdufe_tmpa_tl }
          \skip_horizontal:n { 0.25cm } ：
          \CJKunderline {
            \makebox[6.91cm][c]{ 
              % 小于三个字时，以三个字的宽度分散对齐
              \dim_compare:nNnTF { \l__sdufe_tmpa_dim } < { 3em }
                { \__sdufe_spread_box:nn { 3em }{ \l__sdufe_tmpb_tl } }
                { \l__sdufe_tmpb_tl }
            } 
          }
          \skip_vertical:n { 0.158cm }
        }
    \end{minipage}\par
  }
% %tag 时间
\cs_new_protected:Npn \__sdufe_bachelor_cover_i_date_zh:
  {
    \skip_vertical:n { 4.85cm }

    % \noindent
    % \begin{minipage}[c][0.83cm]{\textwidth}
    %   \kaishu \centering \zihao{-3}
    %   山东财经大学教务处制
    % \end{minipage}
    \noindent
    \begin{minipage}[c][0.83cm]{\textwidth}
      \kaishu \centering \zihao{-3}

      山东财经大学教务处制 \\
      \zhdigits { \int_use:N \l__sdufe_info_year_int }
      \, 年 \,
      \zhnumber { \int_use:N \l__sdufe_info_month_int }
      \, 月
    \end{minipage}
  }

%tag 本科原创性声明
\cs_new_protected:Npn \__sdufe_bachelor_originality_statement:
  {
    \noindent
    \begin{minipage}[b][0.8cm]{\textwidth}
      \centering \zihao{-2} \heiti \bfseries 原创性声明
    \end{minipage}
    \skip_vertical:n { 1.3cm }
    \group_begin:
      \zihao{4}\fangsong
      本人郑重声明：所呈交的论文，是本人在导师的指导下进行研究工作所取得的成果。除文中已经注明引用的内容外，本论文不含任何其他个人或集体已经发表或撰写过的研究成果。对本文的研究做出重要贡献的个人和集体，均已在论文中作了明确的说明并表示了谢意。本声明的法律结果由本人承担。
      \skip_vertical:n { 1.61cm }
      \noindent

      \hspace*{4.653cm} \__sdufe_spread_box:nn{4em}{作者签名}： \CJKunderline{\makebox[5.285cm][c]{ }} \hfil \par
      \noindent
      \hspace*{4.653cm} \hspace*{3em}
      \CJKunderline{\makebox[4em][c]{ }} 年 \CJKunderline{\makebox[2em][c]{ }} 月 \CJKunderline{\makebox[2em][c]{ }}日
    \group_end:
  }
%tag 本科版权使用授权书
\cs_new_protected:Npn \__sdufe_bachelor_copyright:
  {
    \skip_vertical:n { 2.3cm }
    \begin{center}
      \heiti \zihao{-2} \bfseries 版权使用授权书
    \end{center}\par
    \skip_vertical:n { 1.16cm }
    \group_begin:

      \zihao{4}\fangsong
      本人完全了解山东财经大学有关保留、使用论文的规定，即：学校有权保留、送交论文，允许论文被查阅，学校可以公布论文的全部或部分内容，可以采用影印或其他复制手段保存论文。
      \skip_vertical:n { 2.1cm }

      \begin{minipage}{0.5\textwidth}
        \fangsong\zihao{4} 指导教师签名： \CJKunderline*{\hspace*{ 6em }} \hfil \par
        \noindent
        \hspace*{4em}\CJKunderline*{\hspace*{ 2.5em }} 年 \CJKunderline*{\makebox[2em][c]{ }} 月 \CJKunderline*{\makebox[2em][c]{ }}日
      \end{minipage}

      \hfil

      \begin{minipage}{0.5\textwidth}
        \fangsong\zihao{4} 论文作者签名： \CJKunderline*{\hspace*{ 6em }} \hfil \par
        \noindent
        \hspace*{4em}\CJKunderline*{\hspace*{ 2.5em }} 年 \CJKunderline*{\makebox[2em][c]{ }} 月 \CJKunderline*{\makebox[2em][c]{ }}日
      \end{minipage}

    \group_end:
  }


%endregion 封面

%region 摘要和关键词

\cs_new:Npn \__sdufe_bachelor_abstract_output:
  {
    \group_begin:
      \keys_set:nn { ctex } 
        {
          chapter =
            {
              numbering  = false,
              pagestyle  = bachelor-frontmatter,
              format     = \heiti \zihao{3} \centering,
              beforeskip = 15pt,
              afterskip  = 20pt
            }
        }
      
      \begin{minipage}[t]{\textwidth}
        \heiti\zihao{3}\centering
        \l__sdufe_info_title_tl 

        \chapter* { \c__sdufe_name_abstract_tl }
      \end{minipage}
      \skip_vertical:n { 1.16cm }

      \zihao{-4}
      \file_if_exist:nT { pages/abstract.tex }
        {
          \file_input:n { pages/abstract.tex }
        }
      \par

      {\bfseries \c__sdufe_name_keywords_tl ：}
    \clist_use:Nn \l__sdufe_info_keywords_clist {；}
    \group_end:
  }


\cs_new:Npn \__sdufe_bachelor_abstract_en_output:
  {
    \group_begin:
      \keys_set:nn { ctex } 
        {
          chapter =
            {
              numbering  = false,
              pagestyle  = bachelor-frontmatter,
              format     = \normalfont \centering \zihao{3},
              beforeskip = 15pt,
              afterskip  = 20pt
            }
        }

      \begin{minipage}[t]{\textwidth}
        \normalfont\zihao{3}\centering
        \l__sdufe_info_title_en_tl

        \chapter*{ \c__sdufe_name_abstract_en_tl }
      \end{minipage}
      \skip_vertical:n { 1.16cm }

      \zihao{-4}
      \file_if_exist:nT { pages/enabstract.tex }
        {
          \file_input:n { pages/enabstract.tex }
        }
      
      \par 

      {\textbf { \c__sdufe_name_keywords_en_tl :} ~}
      \clist_use:Nn \l__sdufe_info_keywords_en_clist {;~}
    \group_end:
  }

%endregion 摘要和关键词


%tag 输出封面、声明、摘要
\ctex_after_end_preamble:n
{
  \pdfbookmark{中文封面}{titlepage}
  \pagestyle{empty}
  \__sdufe_bachelor_cover_i:

  \pagestyle{bachelor-frontmatter}
  \__sdufe_bachelor_originality_statement:

  \skip_vertical:n { 2.3cm }
  \__sdufe_hhrule:

  \__sdufe_bachelor_copyright:
  \newpage
  \frontmatter
  \__sdufe_bachelor_abstract_output:
  \newpage
  \__sdufe_bachelor_abstract_en_output:
}


%region 目录

%tag 本科设置

\keys_set:nn { ctex }
  { contentsname   = \c__sdufe_name_toc_tl }
% 字体字号
\renewcommand{\cftchapfont}{\heiti \zihao{4}}
\renewcommand{\cftsecfont}{\fangsong \zihao{4}}
\renewcommand{\cftsubsecfont}{\fangsong \zihao{4}}
\renewcommand{\cftchappagefont}{\fangsong \zihao{4}}
% 引导线
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
% 缩进
\dim_set:Nn \cftchapindent { 0em }
\dim_set:Nn \cftsecindent  { 2.5em }
\dim_set:Nn \cftsubsecindent { 4em }
% 计数器宽度
\dim_set:Nn \cftchapnumwidth { 3em }
\dim_set:Nn \cftsecnumwidth { 2.5em }
\dim_set:Nn \cftsubsecnumwidth { 3em }
% 垂直间距
\setlength{\cftbeforechapskip}{0pt}

\titlecontents{chapter}[0pt]{\addvspace{1.5pt}\filright\zihao{4}}
               {\contentspush{第\thecontentslabel 章\quad}}%
               {}{\titlerule*[8pt]{.}\contentspage}

%tag 重定义目录
\cs_set_eq:NN \__sdufe_old_tableofcontents: \tableofcontents
\RenewDocumentCommand \tableofcontents { }
  {
    \group_begin:
    \keys_set:nn { ctex }
      { 
        chapter / format += \centering\bfseries\heiti,
        chapter / pagestyle = \tl_use:N bachelor-frontmatter
      }
    \__sdufe_old_tableofcontents:
    \group_end:
  }

%endregion 目录


%region 插图目录和表格目录
\keys_set:nn { ctex }
  {
    listfigurename = { 插\qquad 图 },
    listtablename  = { 表\qquad 格 }
  }
\cs_set_eq:NN \__sdufe_old_listoffigures: \listoffigures

\RenewDocumentCommand \listoffigures { }
  {
    \group_begin:
    \keys_set:nn { ctex }
      { 
        chapter / format += \centering\zihao{5}\songti,
        chapter / pagestyle = \tl_use:N bachelor-frontmatter
      }
    \__sdufe_old_listoffigures:
    \group_end:
  }

\cs_set_eq:NN \__sdufe_old_listoftables: \listoftables
\RenewDocumentCommand \listoftables { }
  {
    \group_begin:
    \keys_set:nn { ctex }
      { 
        chapter / format += \centering\zihao{5}\songti,
        chapter / pagestyle = \tl_use:N bachelor-frontmatter
      }
    \__sdufe_old_listoftables:
    \group_end:
  }
%endregion 插图和表格


%tag 致谢环境
\NewDocumentEnvironment{acknowledgements}{ +b }
  {
    \newpage
    \vspace*{\fill}
    \begin{minipage}{\textwidth}
      \group_begin:
        \keys_set:nn { ctex }
          {
            chapter / format = \centering\zihao{-2}\heiti\bfseries,
            chapter / beforeskip   = 0.8 \baselineskip,
            chapter / afterskip    = 0.5 \baselineskip,
          }
        \chapter* { 致 \qquad 谢 }
        \addcontentsline{toc}{chapter}{致谢}
        #1
      \group_end:
    \end{minipage}
    \vspace*{\fill}
  }{}

%region 附录设置
\AddToHook { cmd / appendix / after }
  {
    \renewcommand{ \theequation }{ \thechapter \arabic{equation} } 
    \titleformat{\chapter}{\centering\zihao{3}\bfseries}{附录\,\Alph{chapter}}{1em}{}
    \titlecontents{chapter}[0pt]{\addvspace{1.5pt}\filright\zihao{4}}
               {\contentspush{\thecontentslabel}}%
               {}{\titlerule*[8pt]{.}\contentspage}
    \keys_set:nn { ctex }
      {
        section/number = \Alph{chapter}\arabic{section},
        subsection/number = \Alph{chapter}\arabic{section}.\arabic{subsection},
        subsubsection/number = \Alph{chapter}\arabic{section}.\arabic{subsection}.\arabic{subsubsection},
      }
  }
%endregion 附录设置


%region 图表设置
% 本科的最新规定(2024年)是：
% 正文中图、表按章（单元）顺序编号，如图3-1为第三章（单元）第一个图；
% 如表3-1为第三章（单元）第一个表。
%
% 图、表应居中排版；
%
% 图表标题的标注位置应为图下表上，宋体，五号字，以图、表为基准居中对齐。
% 公式必须单独起行，需要时可为公式编号，如公式3-1为第三章（单元）第一个公式，以便于说明和引用。

% 图
\DeclareCaptionFont { sdufefigurecaptionfont }
  { \zihao { 5 } }
% 表
\DeclareCaptionFont { sdufetablecaptionfont }
  { \zihao { 5 } }

\captionsetup [ figure ]
  {
    font     = sdufefigurecaptionfont,
    position = bottom,
    labelsep = space
  }
\captionsetup [ table  ]
  {
    font     = sdufetablecaptionfont,
    position = top,
    labelsep = space
  }
\AddToHook { env / tabular / begin }
  { \zihao{5} }


  
%endregion 图表设置

% 封装 LaTeX 的钩子管理机制。本模板中的字体加载命令位于
% begindocument/before 钩子中，需确保在 xeCJK 之前执行。
\cs_new_protected:Npn \__sdufe_gadd_ltxhook:nn #1#2
  { \hook_gput_code:nnn {#1} { . } {#2} }
\hook_gset_rule:nnnn { begindocument/before } { . } { < } { xeCJK }

%region 参考文献 (bibliography)
%tag 定义变量
\tl_new:N \l__sdufe_bib_backend_tl        % 参考文献后端
\tl_new:N \l__sdufe_bib_style_tl          % 参考文献格式，接受其它值
\tl_new:N \l__sdufe_bib_gb_style_tl       % 参考文献格式（国标），接受 numerical 和 author-year 两个值
\tl_new:N \l__sdufe_cite_style_tl         % 参考文献引用格式
\clist_new:N \l__sdufe_bib_resource_clist % 参考文献 database
%tag 定义键
\keys_define:nn { sdufe / style }
  {
    bib-backend .choice:,
    bib-backend .value_required:n = true,
    bib-backend / bibtex   .code:n =
      { \tl_set:Nn \l__sdufe_bib_backend_tl { bibtex } },
    bib-backend / biblatex .code:n =
      {
        \tl_set:Nn \l__sdufe_bib_backend_tl { biblatex }
        \NewDocumentCommand \addbibresource { m }
          { \clist_gput_right:Nn \l__sdufe_bib_resource_clist {#1} }
      },
    bib-style .choice:,
    bib-style .value_required:n = true,
    bib-style / numerical   .code:n =
      {
        \tl_set:Nn  \l__sdufe_bib_gb_style_tl { numerical  }
        \tl_clear:N \l__sdufe_bib_style_tl
      },
    bib-style / author-year .code:n =
      {
        \tl_set:Nn  \l__sdufe_bib_gb_style_tl { author-year }
        \tl_clear:N \l__sdufe_bib_style_tl
      },
    bib-style / unknown     .code:n =
      {
        \tl_set_eq:NN \l__sdufe_bib_style_tl \l_keys_value_tl
        \tl_clear:N   \l__sdufe_bib_gb_style_tl
      },
    cite-style .tl_set:N = \l__sdufe_cite_style_tl,
    bib-resource .clist_set:N = \l__sdufe_bib_resource_clist
  }
%tag 设置参考文献格式默认值
% 本科默认使用顺序编码制，硕博默认使用著者-出版年制
\tl_if_eq:NnTF \g__sdufe_thesis_type_tl { bachelor }
  {
    \keys_set:nn { sdufe / style } { bib-style = numerical }
  }
  {
    \keys_set:nn { sdufe / style } { bib-style = author-year }
  }
%region 加载宏包
%tag bibtex 此时分两种情况：
% Case 1. bib-style = numerical or author-year，则调用 gbt7714 宏包，此宏包内部调用 natbib 宏包
% Case 2. otherwise，直接调用 natbib
\ctex_at_end_preamble:n
  {
    \tl_if_eq:NnT \l__sdufe_bib_backend_tl { bibtex }
      {
        \tl_if_empty:NTF \l__sdufe_bib_style_tl
          {
            \RequirePackage [ sort & compress ] { gbt7714 }
            \tl_if_eq:NnTF \g__sdufe_thesis_type_tl { bachelor }
              {
                \exp_args:No \bibliographystyle
                  { gbt7714- \l__sdufe_bib_gb_style_tl }
              }
              {
                \exp_args:No \bibliographystyle
                  { gbt7714-2005- \l__sdufe_bib_gb_style_tl }
              }
          }
          {
            \RequirePackage [ sort & compress ] { natbib }
            \exp_args:No \bibliographystyle
              { \l__sdufe_bib_style_tl }
          }
        \__sdufe_bibtex_setup:
      }
  }

%tag biblatex 调用 biblatex 宏包
% biblatex 会写入 begindocument/before 钩子，因此需在其之前通过
% env/document/begin 钩子载入 biblatex 宏包。注意这个
% 钩子仅适用于 \begin{document} 的写法，对于 \document 命令本身无效。
\__sdufe_gadd_ltxhook:nn { env/document/begin }
  {
    \tl_if_eq:NnT \l__sdufe_bib_backend_tl { biblatex }
      {
        \__sdufe_biblatex_pre_setup:
        \RequirePackage { biblatex }
        \__sdufe_biblatex_post_setup:
      }
  }
%endregion

%tag bibtex相关设置
\cs_new_protected:Npn \__sdufe_bibtex_setup:
  {
    \tl_if_eq:NnTF \l__sdufe_bib_gb_style_tl { numerical }
      {
        \exp_args:NNx \DeclareRobustCommand \parencite
          { \exp_args:No \exp_not:o { \cs:w cite ~ \cs_end: } }
        \exp_args:Nc \ctex_patch_cmd:Nnn { parencite ~ }
          { \begingroup }
          { \begingroup \bibstyle@numbers }
      }
      { \cs_set_eq:NN \parencite \cite }
    % 设置引用格式
    \tl_if_empty:NF \l__sdufe_cite_style_tl
      { \exp_args:NV \citestyle \l__sdufe_cite_style_tl }
    % 使用 \textendash 作为数字间的连接号
    \ctex_patch_cmd:Nnn \NAT@citexnum
      { - \NAT@penalty }
      { \textendash \NAT@penalty }
    \cs_set:Npn \bibsection { \__sdufe_chapter:V \bibname }
    % 让 bibtex 的接口与 biblatex 保持一致
    \NewDocumentCommand \printbibliography { o }
      {
        \exp_args:NV \bibliography \l__sdufe_bib_resource_clist
        \IfValueT {##1}
          { \__sdufe_warning:nn { invalid-option-in-bibtex } {##1} }
      }
  }
\__sdufe_msg_new:nn { invalid-option-in-bibtex }
  { Option(s)~ "#1"~ are~ invalid~ in~ BibTeX. }
%tag biblatex相关设置
\cs_new_protected:Npn \__sdufe_biblatex_pre_setup:
  {
    \cs_undefine:N \addbibresource
    \clist_new:N \l__sdufe_biblatex_options_clist
    \clist_put_right:Nn \l__sdufe_biblatex_options_clist { hyperref = manual }
    \clist_put_right:Nx \l__sdufe_biblatex_options_clist % 参考文献样式
      {
        style =
        \tl_if_empty:NTF \l__sdufe_bib_style_tl
          {
            \tl_if_eq:NnTF \g__sdufe_thesis_type_tl { bachelor }
              {
                \str_if_eq:VnTF \l__sdufe_bib_gb_style_tl { numerical }
                  { gb7714-2015 } { gb7714-2015ay }
              }
              {
                \str_if_eq:VnTF \l__sdufe_bib_gb_style_tl { numerical }
                  { gb7714-2005 } { gb7714-2005ay }
              }
          }
          { \l__sdufe_bib_style_tl }
      }
    \tl_if_empty:NF \l__sdufe_cite_style_tl % 引用样式
      {
        \clist_put_right:Nx \l__sdufe_biblatex_options_clist
          { citestyle = \l__sdufe_cite_style_tl }
      }
    \exp_args:NV \PassOptionsToPackage \l__sdufe_biblatex_options_clist
      { biblatex }
  }
\cs_new_protected:Npn \__sdufe_biblatex_post_setup:
  {
    \clist_map_function:NN \l__sdufe_bib_resource_clist \addbibresource
    \__sdufe_biblatex_allow_url_break:
    \__sdufe_biblatex_use_en_dash:
    \defbibheading { bibliography } [ \bibname ] { \__sdufe_chapter:n {##1} }
  }
% biblatex 下允许 URL 在字母、数字和一些特殊符号处断行
\cs_new:Npn \__sdufe_biblatex_allow_url_break:
  {
    \int_set_eq:NN \c@biburlucpenalty  \c_one_int
    \int_set_eq:NN \c@biburlnumpenalty \c_one_int
    \int_set_eq:NN \c@biburllcpenalty  \c_one_int
  }
% 使用 \textendash 作为数字间的连接符
\cs_new:Npn \__sdufe_biblatex_use_en_dash:
  {
    \DefineBibliographyExtras { english }
      {
        \cs_set_nopar:Npn \bibrangedash
          { \textendash \penalty \hyphenpenalty }
      }
    \DefineBibliographyExtras { russian }
      {
        \cs_set_nopar:Npn \bibrangedash
          { \textendash \penalty \hyphenpenalty }
      }
  }
%endregion 参考文献

%tag full-width stop
\keys_define:nn { sdufe / style }
  {
    fullwidth-stop .choice:,
    fullwidth-stop .value_required:n = true,
    fullwidth-stop / catcode .code:n =
      { \__sdufe_set_fullwidth_stop_catcode: },
    fullwidth-stop / mapping .code:n =
      {
        \sys_if_engine_xetex:TF
          {
            \clist_gset:Nn \g__xeCJK_default_features_clist
              { Mapping = fullwidth-stop }
          }
          {
            \sys_if_engine_luatex:T
              {
                \__sdufe_warning:n { mapping-not-available }
                \__sdufe_set_fullwidth_stop_catcode:
              }
          }
      },
    fullwidth-stop / false .code:n = { }
  }
\__sdufe_msg_new:nn { mapping-not-available }
  {
    Option~ "fullwidth-stop = mapping"~ is~ not~ available~ in~ LuaTeX. \\
    "fullwidth-stop = catcode"~ will~ be~ set~ instead.
  }
\cs_new:Npn \__sdufe_set_fullwidth_stop_catcode:
  {
    \char_set_active_eq:NN ^^^^3002 \c__sdufe_fwid_full_stop_tl
    \char_set_catcode_active:N ^^^^3002
    \clist_map_inline:nn
      { \c__sdufe_orig_decl_text_tl, \c__sdufe_auth_decl_text_tl }
      { \tl_set_rescan:Nno ##1 { } {##1} }
  }