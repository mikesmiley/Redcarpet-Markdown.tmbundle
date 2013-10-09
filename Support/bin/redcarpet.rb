#!/usr/bin/env ruby
# Usage: redcarpet [<file>...]
# Convert one or more Redcarpet Markdown files to HTML and write to standard output. With
# no <file> or when <file> is '-', read Markdown source text from standard input.
if ARGV.include?('--help')
  File.read(__FILE__).split("\n").grep(/^# /).each do |line|
    puts line[2..-1]
  end
  exit 0
end

require 'rubygems'
require 'redcarpet'
require 'pygments'

# GitHub Pygments style
css = <<-eos
<style>

/* GitHub-style formatting */
body, html {
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 10px;
  margin: 10px;
  padding: 0;
  color: #333;
}
body {
  font: 13.34px helvetica,arial,freesans,clean,sans-serif;
  line-height: 1.4;
}
.mark { background-color: #ffffcc } /* Highliter */
code { /* GitHub-style inline code */
  margin: 0 2px;
  padding: 0 5px;
  white-space: nowrap;
  border: 1px solid #ddd;
  background-color: #f8f8f8;
  border-radius: 3px;
}
a {
  color: #4183C4;
  text-decoration: none;
}
h1,
h2,
h3,
h4,
h5,
h6 {
  margin: 20px 0 10px;
  padding: 0;
  font-weight: bold;
  -webkit-font-smoothing: antialiased;
  cursor: text;
  position: relative;
}
h1 {
  font-size: 28px;
  color: #000;
  margin-top: 20px;
  margin-bottom: 10px;
  border-bottom: 1px solid #ddd;
}
h2 {
  font-size: 24px;
  border-bottom: 1px solid #ccc;
  color: #000;
}
h3 {
  font-size: 18px;
}
h4 {
  font-size: 16px;
}
h5 {
  font-size: 14px;
}
h6 {
  color: #777;
  font-size: 14px;
}
.highlight pre {
  background-color: #f8f8f8;
  border: 1px solid #ccc;
  font-size: 13px;
  line-height: 19px;
  overflow: auto;
  padding: 6px 10px;
  border-radius: 3px;
}

/* The following is GitHub-style syntax colors */
.c { color: #999988; font-style: italic } /* Comment */
.err { color: #a61717; background-color: #e3d2d2 } /* Error */
.k { color: #000000; font-weight: bold } /* Keyword */
.o { color: #000000; font-weight: bold } /* Operator */
.cm { color: #999988; font-style: italic } /* Comment.Multiline */
.cp { color: #999999; font-weight: bold; font-style: italic } /* Comment.Preproc */
.c1 { color: #999988; font-style: italic } /* Comment.Single */
.cs { color: #999999; font-weight: bold; font-style: italic } /* Comment.Special */
.gd { color: #000000; background-color: #ffdddd } /* Generic.Deleted */
.ge { color: #000000; font-style: italic } /* Generic.Emph */
.gr { color: #aa0000 } /* Generic.Error */
.gh { color: #999999 } /* Generic.Heading */
.gi { color: #000000; background-color: #ddffdd } /* Generic.Inserted */
.go { color: #888888 } /* Generic.Output */
.gp { color: #555555 } /* Generic.Prompt */
.gs { font-weight: bold } /* Generic.Strong */
.gu { color: #aaaaaa } /* Generic.Subheading */
.gt { color: #aa0000 } /* Generic.Traceback */
.kc { color: #000000; font-weight: bold } /* Keyword.Constant */
.kd { color: #000000; font-weight: bold } /* Keyword.Declaration */
.kn { color: #000000; font-weight: bold } /* Keyword.Namespace */
.kp { color: #000000; font-weight: bold } /* Keyword.Pseudo */
.kr { color: #000000; font-weight: bold } /* Keyword.Reserved */
.kt { color: #445588; font-weight: bold } /* Keyword.Type */
.m { color: #009999 } /* Literal.Number */
.s { color: #d01040 } /* Literal.String */
.na { color: #008080 } /* Name.Attribute */
.nb { color: #0086B3 } /* Name.Builtin */
.nc { color: #445588; font-weight: bold } /* Name.Class */
.no { color: #008080 } /* Name.Constant */
.nd { color: #3c5d5d; font-weight: bold } /* Name.Decorator */
.ni { color: #800080 } /* Name.Entity */
.ne { color: #990000; font-weight: bold } /* Name.Exception */
.nf { color: #990000; font-weight: bold } /* Name.Function */
.nl { color: #990000; font-weight: bold } /* Name.Label */
.nn { color: #555555 } /* Name.Namespace */
.nt { color: #000080 } /* Name.Tag */
.nv { color: #008080 } /* Name.Variable */
.ow { color: #000000; font-weight: bold } /* Operator.Word */
.w { color: #bbbbbb } /* Text.Whitespace */
.mf { color: #009999 } /* Literal.Number.Float */
.mh { color: #009999 } /* Literal.Number.Hex */
.mi { color: #009999 } /* Literal.Number.Integer */
.mo { color: #009999 } /* Literal.Number.Oct */
.sb { color: #d01040 } /* Literal.String.Backtick */
.sc { color: #d01040 } /* Literal.String.Char */
.sd { color: #d01040 } /* Literal.String.Doc */
.s2 { color: #d01040 } /* Literal.String.Double */
.se { color: #d01040 } /* Literal.String.Escape */
.sh { color: #d01040 } /* Literal.String.Heredoc */
.si { color: #d01040 } /* Literal.String.Interpol */
.sx { color: #d01040 } /* Literal.String.Other */
.sr { color: #009926 } /* Literal.String.Regex */
.s1 { color: #d01040 } /* Literal.String.Single */
.ss { color: #990073 } /* Literal.String.Symbol */
.bp { color: #999999 } /* Name.Builtin.Pseudo */
.vc { color: #008080 } /* Name.Variable.Class */
.vg { color: #008080 } /* Name.Variable.Global */
.vi { color: #008080 } /* Name.Variable.Instance */
.il { color: #009999 } /* Literal.Number.Integer.Long */
</style>
eos

class HTMLwithPygments < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants # mixin smartypants
  
  # render block code using Pygments.rb
  def block_code(code, language)
    if language
      Pygments.highlight(code, :lexer => language)
    else
      Pygments.highlight(code, :lexer => 'text') # use text lexer if language is not specified
    end
  end
end

def roll_out_the_toc(text)
  toc_renderer = Redcarpet::Render::HTML_TOC.new()
  Redcarpet::Markdown.new(toc_renderer).render(text)
end

def roll_out_the_redcarpet(text)
  # set renderer options
  render_options = {
    :filter_html => true,         # do not allow any user-inputted HTML in the output
#    :no_links => true,            # do not generate any <a> tags
    :with_toc_data => true,       # add HTML anchors to each header in the output HTML, to allow linking to each section
    :hard_wrap => true            # insert HTML <br> tags inside on paragraphs where the origin Markdown document had newlines
  }
  renderer = HTMLwithPygments.new(render_options)
    
  # set the extension options
  extensions = {
    :autolink => true,              # parse links even when they are not enclosed in <> characters
    :space_after_headers => true,   # a space is always required between the # at the beginning of a header and its name
    :fenced_code_blocks => true,    # parse fenced code blocks, PHP-Markdown style
    :tables => true,                # parse tables, PHP-Markdown style
    :strikethrough => true,         # parse strikethrough, PHP-Markdown style (2 ~ characters)
    :no_intra_emphasis => true,     # do not parse emphasis inside of words
    :underline => true,             # parse underscored emphasis as underlines
    :footnotes => true,             # parse footnotes, PHP-Markdown style
    :highlight => true,             # parse highlights. This is ==highlighted==
    :superscript => true,           # parse superscripts after the ^ char, i.e. 2^(nd) time
    :quote => true                  # parse quotes as smart quotes
  }
  Redcarpet::Markdown.new(renderer, extensions).render(text)
end

if ARGV.include?('--clean')
  css = ""
  ARGV.shift
end
input = ARGF.read
STDOUT.write [css, roll_out_the_redcarpet(input)].join

