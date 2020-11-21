Trix.config.blockAttributes = attributes =
  default:
    tagName: "div"
    parse: false
  quote:
    tagName: "blockquote"
    nestable: true
  heading1:
    tagName: "h3"
    terminal: true
    breakOnReturn: true
    group: false
  heading2:
    tagName: "h4"
    terminal: true
    breakOnReturn: true
    group: false
  heading3:
    tagName: "h5"
    terminal: true
    breakOnReturn: true
    group: false
  heading4:
    tagName: "h6"
    terminal: true
    breakOnReturn: true
    group: false
  code:
    tagName: "pre"
    terminal: true
    text:
      plaintext: true
  bulletList:
    tagName: "ul"
    parse: false
  bullet:
    tagName: "li"
    listAttribute: "bulletList"
    group: false
    nestable: true
    test: (element) ->
      Trix.tagName(element.parentNode) is attributes[@listAttribute].tagName
  numberList:
    tagName: "ol"
    parse: false
  number:
    tagName: "li"
    listAttribute: "numberList"
    group: false
    nestable: true
    test: (element) ->
      Trix.tagName(element.parentNode) is attributes[@listAttribute].tagName
  a:
    tagName: "a"
    parse: false
  img:
    tagName: "img"
    parse: false
  p:
    tagName: "p"
    terminal: true
    breakOnReturn: true
    group: false
    test: (element) ->
      Trix.tagName(element.parentNode) != 'li'
  span:
    tagName: "span"
    parse: false
Trix.HTMLParser.parse = (html, options) ->
  html = html.replace(/<[hH][345]/gi, '<strong')
  html = html.replace(/<\/[hH][345]/gi,'</strong')
  html = html.replace(/<[hH][123]/gi,'<h3')
  html = html.replace(/<\/[hH][123]>/gi,'</h3>')
  html = html.replace(/<\/[hH][123]>/gi,'</h3>')
  #html = html.replace(/<p[^>]*>\s*<br\/>\s*<\/p>/gi, '<p></p>')
  parser = new this html, options
  parser.parse()
  parser