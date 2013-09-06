# Headers

Redcarpet requires a space between the hashes and the header text.

```
# Header 1
## Header 2
### Header 3
#### Header 4
##### Header 5
###### Header 6
```

# Header 1
## Header 2
### Header 3
#### Header 4
##### Header 5
###### Header 6

# Phrase Emphasis

    *italic*   **bold**   _underline_  ==highlited== ~~strikethrough~~

*italic*   **bold**   _underline_   ==highlited==   ~~strikethrough~~

Redcarpet is sane enough to not interpret intra-word emphasis markers without escaping:

this_is_not_underlined

# Links

Inline:

	An [example](http://url.com/ "Title")

Reference-style labels (titles are optional):

	An [example][id]. Then, anywhere
	else in the doc, define the link:
	
	  [id]: http://example.com/  "Title"

# Lists

## Numbered Lists

Using a `1. ` makes reordering easy:

	1. Foo
	1. Bar

is rendered as:

1. Foo
1. Bar

## Bullet Lists

    - Foo
    - Bar

- Foo
- Bar

# Blockquotes

	> Email-style angle brackets
	> are used for blockquotes.
	
	> > And, they can be nested.

	> #### Headers in blockquotes
	> 
	> - You can quote a list.
	> - Etc.


# Code Spans

The traditional markdown method of tab or four spaces before each line works, but the following is preferred:

    ```
    # code
    ```

Or, specify a language for syntax highlighting:

    ```ruby
    require 'redcarpet'
    ```

renders as:

```ruby
require 'redcarpet'
```

# Horizontal Rule

    ---

---

# Superscript

    1^st
    2^nd

1^st
2^nd

# Smart Quotes

    "nice quotes"

"nice quotes"

# Line Breaks
Line breaks work as they should without the double-space after each line.

# Images

Inline (titles are optional):

	![alt text](/path/img.jpg "Title")

Reference-style:

	![alt text][id]

	[id]: /url/to/img.jpg "Title"


# References
[Redcarpet](https://github.com/vmg/redcarpet)
[github](http://github.github.com/github-flavored-markdown/)

