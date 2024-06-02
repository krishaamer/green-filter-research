// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): block.with(
    fill: luma(230), 
    width: 100%, 
    inset: 8pt, 
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    new_title_block +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      block(
        inset: 1pt, 
        width: 100%, 
        block(fill: white, width: 100%, inset: 8pt, body)))
}



#let article(
  title: none,
  authors: none,
  date: none,
  abstract: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 11pt,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)

  if title != none {
    align(center)[#block(inset: 2em)[
      #text(weight: "bold", size: 1.5em)[#title]
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[Abstract] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)
#show: doc => article(
  title: [Introduction],
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)


= Introduction
<introduction>
How can college students build closer relationships with sustainability-focused companies? My research project describes the process of designing a sustainable shopping, saving, and investing companion. If used wisely, money can help build communities of sustainable impact.

== Research Relevance
<research-relevance>
My research is timely in 2024 because of the convergence of 5 trends:

#figure(
  align(center)[#table(
    columns: (100%),
    align: (auto,),
    table.header([Supernarratives aka Major Trending Themes],),
    table.hline(),
    [Increasing environmental degradation],
    [Increasing interest in sustainability among young people],
    [Intergenerational money transfer; in some countries relatively young people have money],
    [Increasing availability of sustainability tools such as ESG, B Corporations, Green Bonds, etc, among metrics and instruments],
    [Increasing availability and adoption of generative AI-based user interfaces],
  )]
  , caption: [Trends backing the relevance of this research.]
  , kind: table
  )

== Research Background
<research-background>
I grew up reading science fiction books and their influence on my outlook towards future possibilities continues until present day. In particular, Star Trek has a portable device called a #strong[#emph[tricorder];] (fig.~1), which enables imaginary future humans fix all kinds of problems from looking for minerals inside a cave to scanning human bodies for medical information. I would love to have such a device for consumer choices and financial decisions in order to know what to buy and which businesses to do business with.

== Research Motivation
<research-motivation>
Environmental issues are largely caused by production and manufacturing processes of the companies that make the products we consume on a daily basis. Without reliable and easily accessible data, it’s difficult to know which company is more sustainable than the other. We don’t really know what’s green, unless we spend a lot of time looking at the numbers, which may be costly to access (for example ESG reports are expensive).

AIs are already integral to many parts of our lives; this thesis was partially written using Google’s, Apple’s, and OpenAIs voice recognition software, allowing me to transcribe notes with the help of an AI assistant. As a foreigner living in Taiwan, I’ve relied extensively on AI assistants for many aspects of my life: to communicate, move around efficiently, find food and services. Even when we don’t realize it, AI assistants helping us with many of our mundane tasks. When writing in Chinese, Apple’s text prediction algorithms translate pinyin to 漢字 and show the most likely character based on my previous writing, Google’s maps find efficient and eco-friendly routes and recommend places to eat and ChatGPT provides statistically probable advice from the sum of human knowledge. While it takes incredibly complex computational algorithms to achieve all this in the background, it’s become so commonplace, we don’t even think about it. From this point of view, another AI assistant to help humans with choosing more eco-friendly businesses to show, save, and invest doesn’t sound so much of a stretch.

== Research Objective
<research-objective>
The study presents an AI companion design which seeks to help people build relationships with sustainability-focused companies. The major contribution of this study is an interactive artefact (a prototype) informed by design research.

== Research Demographics
<research-demographics>
My research targets respondents according to the following criteria.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Criteria], [],),
    table.hline(),
    [Location], [Taiwan],
    [Population], [College Students],
    [Count], [700],
  )]
  , kind: table
  )

Interviews with experts (finance, design, sustainability).

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Criteria], [],),
    table.hline(),
    [Location], [Global],
    [Population], [Experts],
    [Count], [5],
  )]
  , kind: table
  )

== Research Questions
<research-questions>
My research aims to answer the following questions.

#figure(
  align(center)[#table(
    columns: (24.66%, 43.84%, 31.51%),
    align: (auto,auto,auto,),
    table.header([№], [Question], [Methods],),
    table.hline(),
    [1], [In general, what are some trends in how sustainability interacts with AI, design, and finance?], [Literature Review],
    [2], [What are some fundamental requirements for designing an AI-assistant aiming to help college students participate in sustainable financial activism?], [Literature Review and Expert Interviews],
    [3], [What features do college students prioritize and what questions would they prefer to ask a sustainability AI assistant?], [Survey (Taiwanese College Student)],
  )]
  , caption: [Table of research questions.]
  , kind: table
  )

#bibliography("ref.bib")

