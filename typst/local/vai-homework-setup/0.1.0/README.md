# Vai Homework Setup

Typst port of the LaTeX homework setup in `tex/HWSetup.tex`.

## Usage

```typ
#import "@local/vai-homework-setup:0.1.0": *

#show: homework.with(
  title: "Title",
  subtitle: "Subtitle",
  due-date: datetime(year: 2025, month: 1, day: 1),
  due-time: "11:59 AM",
  class: "Course - Section",
  class-time: "09:00 AM",
  instructor: "Instructor",
  author: "Author",
)

#problem("1", [Problem title])[
  Problem statement.

  #solution

  #part()

  Solution text.
]
```

Compile a document from the repository root with:

```sh
typst compile --root . --package-path lib/hw-setup/typst reports/main.typ
```

Use `code-file(read("relative/path"), lang: "python")` for external files. The
file is read by the homework document, while the package styles the listing with
`codly`.

The engineering and math shorthand commands from `EngBindings.tex` are
intentionally not ported.
