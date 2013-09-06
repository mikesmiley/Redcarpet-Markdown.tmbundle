# TextMate bundle for Redcarpet::Markdown

[Redcarpet](https://github.com/vmg/redcarpet) is one of the most full-featured markdown renderers available. This TextMate bundle improves upon the default Markdown bundle by taking advantage of all the extra features Redcarpet has to offer.

## Installation

Clone to `~/Library/Application Support/Avian/Bundles` and then run `bundle install`.

## Enabled Features

- autolink
- space_after_headers
- fenced_code_blocks
- tables
- strikethrough
- no_intra_emphasis
- underline
- footnotes
- quote
- highlight
- superscript
- filter_html
- with_toc_data
- hard_wrap

## Ruby Version

This bundle uses Redcarpet 3.0, which requires Ruby > 1.9.3. Meet this requirement using [rbenv](https://github.com/sstephenson/rbenv) and setting these TextMate variables:

- PATH - add path to Ruby `bin` folder to front
- RBENV_VERSION - set to full Ruby version number
- TM_RUBY - set to full path of `ruby` binary

## Syntax Highlighting

Syntax highliting is handled by [pygments.rb](https://github.com/tmm1/pygments.rb) and is rendered using a GitHub-style.