#import "@preview/unify:0.8.1": num, qty, numrange, qtyrange, unit
#import "@preview/cetz:0.5.2" as cetz
#import "@preview/algorithmic:1.0.7" as algorithmic
#import "@preview/codly:1.3.0": codly-init, codly

#let problem-state = state("vai-homework-problem", none)
#let part-state = state("vai-homework-part", 1)

#let _format-date(value) = {
  if type(value) == datetime {
    datetime.display(value, "[month repr:long] [day padding:none], [year]")
  } else {
    value
  }
}

#let _format-time(value) = {
  if type(value) == datetime {
    datetime.display(value, "[hour repr:12 padding:zero]:[minute padding:zero] [period repr:upper]")
  } else {
    value
  }
}

#let _problem-mark() = context {
  let current = problem-state.get()
  if current != none {
    text(size: 9pt)[Problem #current (continued)]
  }
}

#let _continued-footer() = context {
  let current = problem-state.get()
  if current != none {
    text(size: 9pt)[Problem #current continued on next page...]
  }
}

#let _title-page(
  title: none,
  subtitle: none,
  due-date: none,
  due-time: none,
  class: none,
  class-time: none,
  instructor: none,
  author: none,
  completion-date: none,
) = {
  align(center)[
    #v(2in)
    #strong(class)\
    #strong[#title:] #subtitle\
    #v(0.1in)
    #text(size: 9pt)[Due on #_format-date(due-date) at #_format-time(due-time)]\
    #v(0.1in)
    #text(size: 12pt, style: "italic")[#instructor, #_format-time(class-time)]
    #v(3in)
    #strong(author)\
    #v(1em)
    #_format-date(completion-date)
  ]
}

#let homework(
  title: none,
  subtitle: none,
  due-date: none,
  due-time: none,
  class: none,
  class-time: none,
  instructor: none,
  author: none,
  completion-date: datetime.today(),
  body,
) = {
  assert(title != none, message: "homework requires `title`")
  assert(subtitle != none, message: "homework requires `subtitle`")
  assert(due-date != none, message: "homework requires `due-date`")
  assert(due-time != none, message: "homework requires `due-time`")
  assert(class != none, message: "homework requires `class`")
  assert(class-time != none, message: "homework requires `class-time`")
  assert(instructor != none, message: "homework requires `instructor`")
  assert(author != none, message: "homework requires `author`")

  set document(title: title, author: author)
  set text(font: "New Computer Modern", size: 10pt)
  set par(first-line-indent: 0pt, leading: 0.65em)
  set list(indent: 1.25em, body-indent: 0.5em)
  set enum(indent: 1.25em, body-indent: 0.5em)
  show link: set text(fill: blue)
  show: codly-init.with()
  codly(
    display-name: false,
    display-icon: false,
    number-format: n => text(size: 8pt, fill: luma(35%))[#n],
    number-align: right + top,
    number-placement: "outside",
    fill: rgb("#f2f2f2"),
    zebra-fill: none,
    stroke: 0.6pt + rgb("#b3d9f2"),
    radius: 0pt,
    inset: (x: 5pt, y: 4pt),
    smart-indent: true,
    breakable: true,
  )
  show figure: set block(breakable: true)
  set figure(numbering: "0.0.1")

  set page(
    paper: "us-letter",
    margin: (left: 1in, right: 1in, top: 0.55in, bottom: 0.7in),
    footer-descent: 0.25in,
    header: none,
    footer: context align(center, text(size: 10pt)[#counter(page).display()]),
  )

  problem-state.update(none)
  _title-page(
    title: title,
    subtitle: subtitle,
    due-date: due-date,
    due-time: due-time,
    class: class,
    class-time: class-time,
    instructor: instructor,
    author: author,
    completion-date: completion-date,
  )
  pagebreak()

  set page(
    paper: "us-letter",
    margin: (left: 1in, right: 1in, top: 0.55in, bottom: 0.7in),
    header-ascent: 0.25in,
    footer-descent: 0.25in,
    header: context grid(
      columns: (30%, 1fr, 30%),
      align: (left, center, right),
      text(size: 9pt)[#strong(author)],
      text(size: 9pt)[#class (#instructor, #_format-time(class-time)): #title],
      _problem-mark(),
    ),
    footer: context grid(
      columns: (1fr, auto, 1fr),
      align: (left, center, right),
      _continued-footer(),
      text(size: 10pt)[#counter(page).display()],
      [],
    ),
  )
  body
}

#let problem(number, title, break-after: true, body) = {
  problem-state.update(number)
  part-state.update(1)
  heading(numbering: none, outlined: false)[Problem #number: #title]
  body
  problem-state.update(none)
  if break-after {
    pagebreak()
  }
}

#let solution = {
  v(0.55em)
  strong(text(size: 17pt)[Solution])
  v(0.55em)
}

#let part(title: none) = {
  v(0.55em)
  if title == none {
    context {
      let n = part-state.get()
      strong(text(size: 12pt)[Part #numbering("A", n)])
    }
    part-state.update(n => n + 1)
  } else {
    strong(text(size: 12pt)[#title])
  }
  v(0.55em)
}

#let code-heading = {
  v(0.55em)
  strong(text(size: 12pt)[Code])
  v(0.55em)
}

#let code-file(source, lang: none, filename: none) = {
  if filename != none {
    codly(filename: filename)
  }
  raw(source, lang: lang, block: true)
  if filename != none {
    codly(filename: none)
  }
}

#let code-block(source, lang: none) = {
  if type(source) == str {
    raw(source, lang: lang, block: true)
  } else {
    source
  }
}
