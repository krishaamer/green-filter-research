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
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
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
  title: [The Journey from Consumer to Investor: Designing a Financial AI Companion for Young Adults to Help With Sustainable Shopping, Saving, and Investing],
  authors: (
    ( name: [Kris Haamer],
      affiliation: [],
      email: [] ),
    ),
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)

#horizontalrule

title: Abstract sidebar\_position: 1 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= Abstract
<abstract>
== The Journey from Consumer to Investor: Designing a Financial AI Companion for Young Adults to Help With Sustainable Shopping, Saving, and Investing
<the-journey-from-consumer-to-investor-designing-a-financial-ai-companion-for-young-adults-to-help-with-sustainable-shopping-saving-and-investing>
College students are concerned with the environment, yet they are busy with school and hindered by unavailability of simple tools to affect systemic change. Stronger environmental policy from the European Union includes the concept of #strong[#emph[digital product passports];];, which holds the promise to help distinguish #strong[#emph[eco-designed];] products made by #strong[#emph[circular economy];] companies trying to be zero-waste from companies that simply say they are. Tracking product data from the source materials until the consumer, combined with #strong[#emph[data-driven interaction design];] facilitates building transparency into opaque systems. Likewise, advances in the development of #strong[#emph[large-language models];] enables #strong[#emph[artificial intelligence assistants];] to become a translation layer between complex environmental data and human-comprehensible language.

The emerging field of #strong[#emph[Planetary Health];] recognizes profound interconnections between our economic behaviors, ecosystem services such as clean water, air, soil, the climate crisis, and human health. As of 2024, Earth’s natural environment is being heavily degraded by the extractive business practices of companies that make many of the products and services we buy every day. The way we use our money to interact with companies - through shopping as consumers and saving / investing as investors - has an effect on the life-supporting biosphere we rely on to keep our planet inhabitable. In essence, from an ecological perspective, every financial action is either an investment decision to support more environmentally-friendly companies - or to support polluters.

My research addresses the need for tools to make sustainable financial action convenient for college students. I focus on leveraging #strong[#emph[design research];] to find design concepts for #strong[#emph[simple AI user interfaces];] also known as #strong[#emph[generative UI];] to help college students participate in #strong[#emph[sustainable financial activism];];. A survey of 700 students across 10 universities in Taiwan was conducted, enhanced by 5 expert interviews providing industry insights. The major contribution of the study is an interactive AI-assistant prototype.

Keywords: Climate Anxiety, Human-AI Interaction, Digital Sustainability, Financial Activism, Transparency, Planetary Health

= Abstract in Chinese \*
<abstract-in-chinese>
== 從消費者到投資者的旅程：為年輕成人設計一個財務AI夥伴，幫助他們進行可持續購物、儲蓄和投資
<從消費者到投資者的旅程為年輕成人設計一個財務ai夥伴幫助他們進行可持續購物儲蓄和投資>
大學生關注環境問題，但因學業繁忙及缺乏簡便工具來影響體制改變而受阻。歐盟更強化環保政策，引入了「數位產品護照」的概念，此舉有望幫助區分由循環經濟公司製造的、努力實現零廢棄的「生態設計」產品，與僅聲稱自己環保的公司。從原材料到消費者的產品數據追踪，結合「數據驅動的互動設計」，有助於為不透明系統建立透明度。同樣地，「大型語言模型」的發展使得「人工智能助理」能夠成為複雜環境數據與人類可理解語言之間的翻譯層。

新興的「地球健康」領域認識到我們的經濟行為、生態系統服務（如淨水、空氣、土壤）、氣候危機與人類健康之間存在深刻的相互聯繫。截至2024年，地球的自然環境正被開採性企業的商業行為嚴重破壞，這些企業生產我們每天購買的許多產品和服務。我們通過消費和儲蓄/投資與公司的互動方式，對我們賴以生存的、支持地球可居住生物圈產生影響。從生態學的角度看，每一個財務行動都是支持更環保公司的投資決策，或是支持污染者。

我的研究應對了為大學生提供便於實行可持續財務行動的工具需求。我專注於利用「設計研究」來尋找「簡易AI用戶介面」的設計概念，也稱為「生成UI」，以幫助大學生參與「可持續財務行動主義」。在台灣10所大學進行了一項涵蓋700名學生的調查，並增加了5位專家訪談以提供行業見解。研究的主要貢獻是一個互動AI助理原型。

關鍵詞：氣候焦慮、人工智能互動、數位可持續性、財務行動主義、透明度、地球健康。

- The abstract was translated on May 22, 2024 using the Claude 3 Opus model. Translation quality was checked with OpenAI GPT4, Google Gemini, Mistral Large, Meta LLama as well as human reviewers. In case of any discrepancies, please refer to the English text.

#horizontalrule

title: Introduction sidebar\_position: 2 editor: render-on-save: false suppress-bibliography: true CJKmainfont: STSong CJKoptions: - BoldFont=STHeiti - ItalicFont=STKaiti

#horizontalrule

= Introduction
<introduction>
How can college students find sustainability-focused companies? My research project describes the process of designing a sustainable shopping, saving, and investing companion. If used wisely, money can help build communities of sustainable impact and helpo build closer relationships with sustainability.

== Research Relevance
<research-relevance>
My research is timely in 2024 because of the convergence of the following 5 major trending themes:

#figure(
  align(center)[#table(
    columns: (100%),
    align: (auto,),
    table.header([Supernarratives],),
    table.hline(),
    [Increasing environmental degradation],
    [Increasing interest in sustainability among young people],
    [Intergenerational money transfer; in some countries relatively young people have money],
    [Increasing availability of sustainability tools such as ESG, B Corporations, Green Bonds, etc, among metrics and instruments],
    [Increasing availability and adoption of generative AI-based user interfaces],
  )]
  , caption: [Current trends backing the relevance of this research.]
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
    columns: (26.39%, 41.67%, 31.94%),
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

#horizontalrule

title: Literature Review sidebar\_position: 3 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

== Sources and Literature Map
<sources-and-literature-map>
Given the goal of designing an app to integrate shopping, saving, and investing sustainably, the literature is quite broad. The literature review maps out relationships between sustainability and AI interaction design. The reviewed content consists of 3 main sources:

- Scientific papers (largely from ScienceDirect) related to:

- Sustainability, ecology, ecosystem services

- Sustaimable investing, savings, circular economy

- UX/UI, service design, sustainable design, speculative design, interaction design

- Generation-Z demographics, behavior change, nudge

- Review of Mobile apps (Apple iOS / Google Android) and web app related to:

- Sustainable shopping apps, savings, and investing

- Apps using algorithmic interfaces (AI-based UI)

- EU legislation

In order to keep track more easily, each literature review section includes #strong[design implications] in context.

The goal of the literature review is to find ideas of app features.

#horizontalrule

title: Students sidebar\_position: 1 editor: render-on-save: false suppress-bibliography: true CJKmainfont: STSong CJKoptions: - BoldFont=STHeiti - ItalicFont=STKaiti

#horizontalrule

== Student Protests Around the World
<student-protests-around-the-world>
In August 2018, Swedish high-school student Greta Thunberg skipped class to start a climate strike in front of the Swedish parliament Riksdag. Millions of people around the world joined her #emph[Fridays for Future] protests. Time magazine named Thunberg person of the year for #emph[creating a global attitudinal shift] @deutschewelleFridaysFutureGlobal2019.

== College Students in Taiwan
<college-students-in-taiwan>
@changExploringDialogicEducation2023 argues Taiwanese culture is influenced by Confucianism and Daoism, which affect education to be #strong[#emph[teacher-centered];];, where traditionally the role of students is to listen and absorb knowledge; there are open opportunities to revisit #strong[#emph[dialogue-based];] education, where students would be encouraged to take a more active role and gain ownership of their education.

Taiwan has an aging population @gohLongrunMacroeconomicConsequences2023.

== Online Shopping
<online-shopping>
- #cite(<momovscoupang2024>, form: "prose") predicts Momo and Coupang will compete for Taiwanese market leadership.

=== Teachers
<teachers>
- Elementary-school teachers in Taichung (n=536), have positive attitudes towards environmental education are positive, proactive and demonstrate high awareness; they have participated in many sustainability-related workshops @liaoElementaryTeachersEnvironmental2022. Taiwanese government launched the Sustainable Council in 1997 to promote of environmental and sustainable development; a survey of university-level teachers (n=100) in central Taiwan (Taichung, Changhua, and Yunlin) shows a positive attitude toward environmental sustainability among teachers however implementation of environmental sustainability practices is from low to medium range @FenXi2015.

=== Policy Environment
<policy-environment>
- In Portugal, Estonia, and elsewhere young peoople are suiing companies for eco-proboems: https:\/\/www.publico.pt/2024/04/09/azul/noticia/nao-acaba-aqui-garantem-jovens-portugueses-decisao-tribunal-europeu-2086381

- Comparing university students’ education for sustainable development (ESD) in Taiwan (n=617) and Sweden (n=583); Sweden has a long history in environmental education while in Taiwan environment became a focus area with the 1998 educational reform #cite(<berglundCrossculturalComparativeStudy2020>, form: "prose");.

- The En-ROADS climate change solutions simulator @czaikaModelUseSustainability2017@creutzigEngageDonPreach2020@climateinteractiveLIVECOP28EnROADS2023.

- "Research shows that showing people research doesn’t work," John Sterman https:\/\/www.climateinteractive.org/lead-an-even

- https:\/\/en-roads.climateinteractive.org/scenario.html?v=24.4.0

- Several Taiwanese studies focus on the physical environment of school campuses, for example the sustainability of #strong[elementary school campuses] @YanJiu2006.

- The devastating nuclear disaster in Fukushima, Japan, after 2011 earthquake, had an effect on Taiwanese energy and sustainability education @TiChuTan2011.

=== Students
<students>
- @GuoZhongXueShengWeiLi2003 reports #emph[good knowledge of sustainable development] topics among #strong[junior high school students] in Da-an District, Taipei City (n=596). @GaoZhongXueShengWeiLi2009 similarly reports a positive attitude and good knowledge of environmental sustainable development among senior #strong[high school students] towards in Taipei City (n=328). @chenMarineEnvironmentalAwareness2016 reports a #strong[#emph[positive attitude yet moderate knowledge];] about #emph[ocean sustainability] among Taiwanese #strong[college students] (n=825).

- @liuDigitalCapabilityDigital2023 studied sustainability behavior of Taiwanese University students reporting the COVID-19 pandemic also brought more attention on environmental topics .

- When it comes to learning about environmental issues at the pre-university level, Taiwanese government has been promoting green schools through a green school network; however surveys at middle school and high school level suggest there is no impact on #emph[sustainability consciousness] among students in comparison with regular schools @olssonGreenSchoolsTaiwan2019. Rather, Taiwanese students are influenced towards environmental action by #emph[group consciousness] @yuUnderstandingTaiwaneseUndergraduate2017.

- I was unable to find similar research on university and post-graduate level students in Taiwan.

- Taiwanese college students and SDGs @hoImportancePerformanceSDGs2022.

- College students in tourism and related fields . and sustainability

=== Global Data
<global-data>
- @manchandaCultivatingSustainabilityConsciousness2023 survey (n=726) administered at shopping malls in New Delhi, India, found similar levels of sustainability consciousness between Millenial (n=206) and Generation-Z (n=360) age groups; people with high level of materialism were found to be less sustainability-conscious; the effect of mindfulness on sustainability was found to be stronger among females than males, supporting the hypothesis of the moderating effect of gender.

#strong[There’s evidence young people have money.] In the United States, the combined annual consumer spending of generation-z and millennials was over 2.5 Trillion USD in 2020 @ypulseMillennialsGenTeens2020. Over the decade from 2020 to 2030, in the U.S., UK, and Australia, Millennials are projected to inherit 30 trillion USD from their parents @calastoneMillennialsInvestingDetailed2020. There’s also some evidence of investment interest, however there’s large geographic variance. According to a @calastoneMillennialsInvestingDetailed2020 study (n=3000) surveying people in the millennial age group between ages 23 and 35 in Europe (UK, France, Germany), U.S.A., Hong Kong, and Australia, 48% of respondents located in Hong Kong owned financial securities (such as stocks) while the figure was just 10% in France.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Place], [Percentage of Financial Security Ownerneship],),
    table.hline(),
    [Hong Kong], [48%],
    [France], [10%],
    [], [],
  )]
  , caption: [From millennial investors @calastoneMillennialsInvestingDetailed2020.]
  , kind: table
  )

=== Sustainability Tools in the Taiwanese Context
<sustainability-tools-in-the-taiwanese-context>
Musical garbage truck are a success story of the environmental progress in Taiwan @helendavidsonClassicalTrashHow2022. Indeed, they are a #emph[user interface innovation] and the main way how people in Taiwan interact with sustainability issues.

The popular narrative about Taiwan recounts the story of the economic and environmental transformation of the country. In the late 1980s during the heights of an economic boom Taiwan became famous as the Taiwanese Miracle (臺灣奇蹟) @goldStateSocietyTaiwan1986@tsaiExplainingTaiwanEconomic1999. By the early 1990s another less flattering nickname appeared: "garbage island", for the piles of trash covering the streets and overflowing landfills @rapidtransitionsallianceTaiwanTransitionGarbage2019@ngoHowGettingRid2020. In the two decades that followed, from 1998 to 2018, Taiwan made progress in municipal waste management, rising to the status of a world-leader in recycling (2nd #emph[effective recycling rate] after Germany); in addition to an effective recycling system, the average waste amount generated per person by 700g (from 1140g to 400g) per day; nonetheless, industrial recycling rates were less stellar, standing at 80% in 2020 and there were unrealized opportunities in using industry 4.0 technologies, such as internet of things (IoT) sensors for better waste tracking @wuSupportingCircularEconomy2021@buiMunicipalSolidWaste2023.

Progress in sustainability is possible but achieving results takes time and innovation. @rapidtransitionsallianceTaiwanTransitionGarbage2019 credits the Taiwanese Homemakers United Foundation (財團法人主婦聯盟環境保護基金會) for initiating the transformation in 1987, suggesting a small group of people can have an outsized impact on the whole country. Their activity didn’t stop there and @CaiTuanFaRenZhuFuLianMengHuanJingBaoHuJiJinHuiBenHuiJianJie2020 recounts a timeline of their achievements on their website until the present day.

- Progress in other areas of environmental protection has not made similar progress.

- There are documentaries about oil product

- Plastic production documentary

- I’ve seen several.. find and cite them to show the progression of the environmental movement in Taiwan ADD CITATION

- The Taiwanese Green party

- Contact SOAS?

=== Developing Personas
<developing-personas>
User research makes extensive use of user #emph[personas] to represent a group of people with similar attributes. Designers use personas to #emph[articulate assumptions,] which, if used well, is useful for #emph[user-centered design];, to create better products. Personas help to reflect on what kind of #emph[biases] might exist in the design. Within the larger cohort of college students several different personas could be defined, for example grouping people by interests, knowledge, habits, levels of anxiety, and other attributes.

Humans have a long list of cognitive biases, which a good design should take into account.

There is extensive research on the attitudes of U.S. college students towards climate change. @americanpressinstituteKnowingNewsHow2022 reports only 37% percent of U.S. Generation-Z and Millenials follow news related to environmental issues. @schwartzClimateChangeAnxiety2022 reports some adult US students in a small study (18-35, n = 284) express feelings of insignificance of their actions to achieve any meaningful impact. @thomaesGreenTeensUnderstanding2023 reports U.S. adolescents don’t find sustainability relevant to their daily life. @rossClimateChangeChallenge2016 says most people in the U.S. don’t act on climate change. "Action on climate change has been compromised by uncertainty, aspects of human psychology".

- Students in the Generation-Z age bracket (abbreviated as Gen-Z or Zoomers) are born between 1997 and 2012 @brankavuletaGenerationStatistics2023. Over 98% of Gen-Z owns a smartphone while only 80% of the general world population does @globalwebindex98GenOwn2017@bankmycellHowManyPeople2022.

- High levels of technology adoption worldwide

- @creditsuisseYoungConsumersMay2022 suggests young consumers are more eco-friendly and drive the speed of change. Yet the Economist has ran a few anonymous articles calling gen-z green ideals into question @theeconomistHowSellYoung2023@HowGenMillennials2023.

- #cite(<deyangeorgiev39SmartphoneStatistics2023>, form: "prose")

- #cite(<alexreiceMostEcoconsciousGeneration2021>, form: "prose")

The above studies give foundation for creating a persona of a U.S. College Student who doesn’t follow environmental news and thinks climate action doesn’t make a difference. This doesn’t necessarily mean this group of people with similar ideas would deny climate change is happening. Rather "Climate Denier" could be another persona, grouping people into a cohort who thinks climate change is not real. Further research would be needed to define relevant personas which have meaningful predictive and generalizing power.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Description], [Name], [Beliefs],),
    table.hline(),
    [Climate Change Denier], [Jake], [Climate change doesn’t exist.],
    [], [Alice], [],
    [], [Sam], [],
  )]
  , caption: [College Student Personas]
  , kind: table
  )

- #cite(<crabbRantTerriblePersonas2023>, form: "prose")

#cite(<RooneyVargaClimateActionSimulation2019>, form: "prose") shows the effectiveness of #strong[#emph[The Climate Action Simulation];] in educating users about #strong[success scenarios];.

=== Social Trust
<social-trust>
- When disaster hits we need high levels of social trust.

=== Climate Anxiety
<climate-anxiety>
A large worldwide study (n=10000, age 16-25) by @hickmanClimateAnxietyChildren2021 provides evidence the youth is anxious about climate in Australia, Brazil, Finland, France, India, Nigeria, Philippines, Portugal, the UK, and the USA. Similarly, @thompsonYoungPeopleClimate2021 finds young people around the world have climate anxiety. @whitmarshClimateAnxietyWhat2022 shows worry about the climate in the UK is generally widespread (over 40% of the respondents, n=1332), while climate anxiety is highest among young people and is a possible motivator for climate action. Additionally, @ogunbodeClimateAnxietyWellbeing2022 finds climate anxiety in 32 countries and also supports the idea that climate anxiety leads to climate activism. @thibodeauThreeCompaniesClosing2022: "In 2021, the BBC polled 1,000 people in Scotland to understand the barriers to taking climate action. What they found was even though many people were aware of actions needed to take to address climate change, and had intentions to their behaviors didn’t change. This is a phenomenon called the intention-action gap."

- @osakaWhyClimateDoomers2023 argues #emph[doomerism] is an excuse for climate in-action. Hope is necessary for people to make changes in their habits @marlonHowHopeDoubt2019.

- Designing for Health and Sustainability: Health and sustainability are intrinsically connected. @kjaergardHealthSustainability2014 shows how "understanding health and sustainability as a duality, health both creates conditions and is conditioned by sustainability, understood as economic, social and environmental sustainability, while on the other hand sustainability creates and is conditioned by human health"

- Design for Human Rights @unfcccSharmElSheikhImplementation2023\] text refers to "human right to a clean, healthy and sustainable environment".

- Refi podcast: "people need agency".

- #cite(<martiskainenContextualizingClimateJustice2020>, form: "prose") (need access, ncku doesn’t subscribe)

- #cite(<seabrookMusicTherapyEra2020>, form: "prose") (need access)

- Older research on young adults (Millenials at the time) highlights how Millenials "use Google as a reference point for ease of use and simplicity" @katemoranDesigningYoungAdults2016.

=== Embodied Carbon
<embodied-carbon>
- "embodied carbon"
- Carbon Neutral Cities Alliance
- #cite(<buildersforclimateactionMakingRealZero2021>, form: "prose")

=== Community
<community>
Humans working together are able to achieve more than single individuals. "Any community on the internet should be able to come together, with capital, and work towards any shared vision. That starts with empowering creators and artists to create and own the culture they’re creating. In the long term this moves to internet communities taking on societal endeavors."

- Building a culture of sustainability? @lakshmirebeccaManWhoGamifying2018@armstrongCultivatingCulturesSustainability2021.

The focus on #emph[group consciousness] suggests community-based sustainability action may be effective.

#strong[#emph[Zero Waste Lifestyle];] is the opposite of overconsumption. Zero waste suggests people buy in bulk to save. Buying in bulk for more savings and to reduce packaging. Through group purchases and community investing while also reducing consumption. - Zero waste municipality in Treviso

- In one Australian study, green consumers still waste food similarly to the baseline @mccarthyFoodWasteGreen2017.

#strong[#emph[Minimalism];] is a movement of people living a simple life. This is always going to be a small percentage of people. @costaHowFinnishCulture2018: Finnish socialists: minimalism. Tokyo @tokyosimpleecolifeWhatLearnedMy2021.

What are the building blocks of a thriving community?

- Taiwan is a growing market for luxury brands @karatzasConsumersPerceptionsComplexity2019.

=== Empowerment
<empowerment>
- I would like to have an AI agent to set my requirements and preferences and give a "fuck you" middle finger to companies that don’t meet them. I could also give a thumbs up to companies that meet my expectations. Perhaps the user interface could like Tinder where I can swipe left and right.

=== Trust
<trust>
- plap

=== Memes
<memes>
- Coined by Richard Dawkins in 1976 in the context of biology.

- Internet memes and meme stocks

- Memes from daily life, business to war, are relevant to penetrating through the noise of the web.

- Memes and sustainability?

- Meme research has become an academic discipline

- Memes have become a popular communication tool..

- #cite(<zidaniMessyInternetMemes2021>, form: "prose")

- #cite(<zidaniHowConductInternet2022>, form: "prose")

- #cite(<irinalyanWhenGangnamHits2015>, form: "prose")

- #cite(<zannettouOriginsMemesMeans2018>, form: "prose")

- #cite(<peters-lazaroPopularCultureCivic2020>, form: "prose")

== Design Implications
<design-implications>
== College Students Need Tools for Action
<college-students-need-tools-for-action>
Environment shapes action.. create an environment where college students can influence companies.

#figure(
  align(center)[#table(
    columns: (34.72%, 65.28%),
    align: (auto,auto,),
    table.header([Category], [Implication],),
    table.hline(),
    [Community], [Taiwanese students are influenced by the actions of their peers; the app should show what other people are doing.],
    [], [People exist in relation to other people.],
    [], [Psychology of 'fundraising clubs' vs individual investing],
    [], [#cite(<UkraineDAOBiddingUkrainian>, form: "prose") Ukraine DAO to support Ukraine through web3.],
    [], [These social movements are small and require too much effort to be feasible for the app? Most college students are not zero waste or minimalist.],
    [], [Group Purchases.],
    [], [Find Your Composting Community.],
    [], [Provides a community for pooling money with like-minded investors.],
    [Climate Anxiety], [How to support the youth? Design to reduce climate anxiety? Is getting people to go to nature more a good way to increase ecological awareness? Empowered by Design. Youth empowerment: The design should empower young people.],
    [], [Consumer branded carbon credits like angry teenagers?],
    [], [Invest time not money, student don’t have money?],
    [Social Trust], [#strong[Show Success Scenarios!];],
    [], [Ask how much time you want to contribute.],
    [], [Match with other people based on time.],
    [], [Create a group chatroom.],
    [], [Use AI to help out with tips.],
    [], [Ask university students what do they study and match with that industry to become expert and sustainability leader in this field.],
    [], [People want to help and make a difference. Give people things to do. The #cite(<dontlookupMethodology>, form: "prose") part of the #strong[#emph[Don’t Look Up];] movie’s social campaign provides 5 user models / roles for the audience to follow: Consumer, Investor, Activist.],
    [], [Choose Your Climate Solutions.],
    [], [Younger people show higher motivation (participants in climate protests). How to be relevant for a younger audience?],
    [], [Yet action remains low.],
    [], [Targeted and gated to college students.],
    [], [FB, etc, Gas all had the same launch strategy - start with students],
    [], [#cite(<kuzminskiEcologyMoneyDebt2015>, form: "prose") ecology of money],
    [], [Young people are mobile-first],
    [], [Persona: I care mostly about… fashion, art, …],
    [], [Young people like to follow trends.],
    [], [Food ordering apps are popular.],
    [], [Monoculture to regenerative food forests Oil to electric cars / bicycles.],
    [], [Social Educational Edutainment Fun],
    [], [#cite(<aespaAespaEseupaMY2020>, form: "prose");: Karina from Korea. It makes sense your sustainability assistant would talk to you. Studies show gen N is speaking to computers all the time. Interacting with the user is on the rise. For example, Chime makes tipping suggestions on the place of purchase.],
    [], [The demographics that stand to win the most from the green transformation of business are the youngest generations, with more years of life ahead of them, and more exposure to future environmental and social risks. It would be advisable for Generation Z and their parents (Millennials) to invest their resources in greener assets, however, it’s still difficult to pick and choose between 'good' and 'bad' financial vehicles to invest in.],
    [], [This creates an opportunity for a new generation of sustainable investment apps, focusing on the usability and accessibility of ESG for a mainstream audience. Generation Z and Millennials expect a consumer-grade user experience.],
    [], [What would that experience look like? I’ve chosen these demographics with the assumption that if given the right tools, the emotional demand for sustainability could be transformed into action. The exploration of systems of feedback to enable consumers to apply more direct positive and negative pressure to the businesses and consumers signal consequences for undesirable ecological performance is a major motivation of this study.],
  )]
  , kind: table
  )

#horizontalrule

title: Sustainability sidebar\_position: 1 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

== Evolving Sustainability Measurments from Planetary Boundaries to Planetary Health
<evolving-sustainability-measurments-from-planetary-boundaries-to-planetary-health>
#emph[Sustainability] was first mentioned in the seminal book #emph[Sylvicultura oeconomica] in the context of forestry with the goal of achieving sustainable forest management @hannsscarlvoncarlowitzSylviculturaOeconomicaOder1713. The field is known today as #emph[sustainable yield] of #emph[natural capital] with a focus on maintaining #emph[ecosystem services] @peterkareivaNaturalCapitalTheory2011. Aldo Leopold proposed the idea of #emph[land ethics] as #emph["\[a\] thing is right when it tends to preserve the integrity, stability, and beauty of the biotic community. It is wrong when it tends otherwise"] in his landmark work #emph[A Sand County Almanac] @leopoldSandCountyAlmanac1972. The 1987 United Nations’ Brundtland Report (Our Common Future) defined sustainable development as #emph["Development that meets the needs of the present without compromising the ability of future generations to meet their own needs"] @worldcommissiononenvironmentanddevelopmentOurCommonFuture1987.

In 1896, the Nobel Prize winner Svante Arrhenius first calculated how an increase in CO#sub[2] levels could have a warming effect on our global climate @andersonCO2GreenhouseEffect2016@wulffPetterLegacy2020. 120 years later, the Paris Climate Agreement came into effect, with countries agreeing on non-binding targets on how to keep CO#sub[2] levels 1.5 °C below pre-industrial levels @unitednationsParisAgreement2016. While awareness of Earth’s warming climate was growing, the CO#sub[2] emissions kept rising too. The hockey-stick growth of CO#sub[2] concentration since the industrial revolution is clear in the data from 1958 onward, following a steady annual increase, called the #emph[Keeling Curve] @keelingAtmosphericMonthlySitu2017. Written records of global temperature measurements are available starting from the 1880s when documentation of temperatures become available in ship records @BrohanClimate2012. Temperature estimations from tree-trunks allow some temperature comparisons with the climate as far back as 2000 years ago @rubinoLawDomeIce2019.

In 1938, Guy Stewart Callendar was the first to demonstrate the warming of Earth’s land surface as well as linking the production of fossil fuels to increased CO#sub[2] and changing climate @hawkinsIncreasingGlobalTemperatures2013. By the latest data from 2022, the current world population of 8 Billion people emitted 37.5 gigatonnes of CO#sub[2] per year, the highest emissions recorded in history @statistaAnnualCO2Emissions2023. To limit global warming to 1.5 °C as agreed by the world nations in Paris, removal of 5-20 gigatons of CO#sub[2] per year would be needed according to reduction pathways calculated by the Intergovernmental Panel on Climate Change (IPCC) @wadeMoisturedrivenCO2Pump2023. Yet, most countries are missing the mark. Given this model of climate change, the G7 countries (Canada, France, Germany, Italy, Japan, United Kingdom, United States) are heading for 2.7 °C of warming by 2050 @cdpMissingMarkCDP2022. The monumental task of removing several gigatons of CO#sub[2] from the atmosphere requires massive policy shifts and collaboration across countries and industries @macklerPolicyAgendaGigatonscale2021.

News reports saying quoting the "The European Union’s Copernicus Climate Change Service (C3S)" 1.5 has already been breached @WorldFirstYearlong2024@FirstTimeWorld2024.

In 1948, the International Union for Conservation of Nature (IUCN) was founded, which in

LULUCF "Land Use, Land-Use Change, and Forestry" can be a source of greenhouse gas emissions or a carbon sink (removing CO2 from the atmosphere)

In addition the enormity of emissions, humanity is facing other massive problems. The Stockholm Resilience Centre reports we have already breached 4 out of our 9 planetary boundaries: in addition to climate change, biodiversity loss (Extinctions per Million Species per Year aka E/MSY), land-system change (deforestation, land degradation, etc), and biogeochemical flows (cycles of carbon, nitrogen, phosphorus, etc); on a positive side, the challenges of fresh water use, ocean acidification and stratospheric ozone depletion are still within planetary limits @perssonOutsideSafeOperating2022.

Atmospheric aerosol loading and the biodiversity intactness index (BII) were quantified recently (ADD CITATION)

- @keebleBrundtlandReportOur1988 reported in April 1987 that #emph['residents in high-income countries lead lifestyles incompatible with planetary boundaries'];. While my home country Estonia at the time was considered low-income, a small nation in poverty behind the #emph[Iron Curtain] occupation of the Soviet Occupy, we now in 2023, have indeed reached high-income status.
- #cite(<debalieKateRaworthCreating2018>, form: "prose")
- #cite(<houdiniPlanetaryBoundariesAssessment2018>, form: "prose")
- #cite(<haeggmanPlanetaryBoundariesAnalysis2018>, form: "prose")

==== Planetary Boundaries
<planetary-boundaries>
- As long as humanity is a mono-planetary species, we have to come to terms with the limitations of our home, Earth.

=== Planetary Health
<planetary-health>
- Planetary health https:\/\/unfccc.int/climate-action/un-global-climate-action-awards/planetary-health

- #cite(<wardaniBoundariesSpacesKnowledge2023>, form: "prose") #emph["long-term human well-being is dependent on the well-being of the planet, including both biotic and abiotic systems. It recognizes interlinkages across environmental sustainability, public health, and socioeconomic development."]

=== Biodiversty Loss
<biodiversty-loss>
Protecting biodiversity

#figure(
  align(center)[#table(
    columns: (62.34%, 37.66%),
    align: (auto,auto,),
    [What Happened?], [How Much?],
    [Vertebrate species population average decline], [68% over the last 50 years],
    [Land surface altered by humans], [70% of Earth],
    [Vertebrate species extinct], [700 in 500 years],
    [Plant species extinct], [600 in 500 years],
    [Species under threat of extinction], [1 million],
  )]
  , caption: [Biodiversity loss data from @bradshawUnderestimatingChallengesAvoiding2021.]
  , kind: table
  )

- The current environmental upheaval, led by Gen-Z and Millennials, and the business adaptation (or lack thereof) to sustainable economic models, taking into account the hidden social and environmental costs we didn’t calculate in our pricing before.
- We also need to consider environmental effects (E in ESG). We haven’t taken into account the whole cost of production, leading to the wrong pricing information. To achieve this, we need expert governance (G).

Consumer lifestyle contributes to environmental destruction. According to #cite(<ellenmacarthurfoundationmaterialeconomicsCompletingPictureHow2019>, form: "prose");’s models show 45% of CO#sub[2] equivalent emissions come from our shopping; produced by companies to make the products we consume. A large scale study by #cite(<anthonyleiserowitzInternationalPublicOpinion2022>, form: "prose") on Meta’s Facebook (n=108946) reported people in Spain (65%), Sweden (61%), and Taiwan (60%) believe #emph["climate change is mostly caused by human activities".] An even larger survey (n=1.2 million) by the United Nations across 50 countries, distributed through mobile game ads, showed the majority of people agreeing climate change is an "emergency" #cite(<undpPeoplesClimateVote2021>, form: "prose");. While people express eco-conscious ideas, it’s non-trivial to practice sustainability in daily life. #cite(<deyangeorgievGenStatisticsWhat2023>, form: "prose") reports only 30% of people in the Gen-Z age group believe technology can solve all problems.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Age Group], [Agree], [Neutral or Disagree],
    [18-35], [65%], [35%],
    [36-59], [66%], [34%],
    [Over 69], [58%], [42%],
  )]
  , caption: ["Climate change is an emergency" #cite(<undpPeoplesClimateVote2021>, form: "prose");.]
  , kind: table
  )

AI is being used to maps icebergs and measure the change in size #cite(<europeanspaceagencyAIMapsIcebergs2023>, form: "prose")

== Ecological Indicators of the Biosphere
<ecological-indicators-of-the-biosphere>
Sustainability can be measured using a variety of #strong[#emph[ecological indicators];];.

#cite(<dinersteinEcoregionBasedApproachProtecting2017>, form: "prose") identifies 846 terrestrial ecoregions.

- Svalbard Seed Vault
- #cite(<jacksonMaterialConcernsPollution1996>, form: "prose") #emph[preventive environmental management]
- #cite(<jacksonProsperityGrowthFoundations2017>, form: "prose") limits to growth update
- Ecological Indicators (I like the name Ecomarkers) for Earth are like Biomarkers in human health.

Some argue sustainability is not enough and we should work on regeneration of natural habitats.

=== The Climate
<the-climate>
==== The Price of Climate Change
<the-price-of-climate-change>
Long term cost is more than short-term gains.

==== Climate Data Vizualisation
<climate-data-vizualisation>
Climate data visualization has a long history, starting with #strong[#emph[Alexander von Humboldt,];] the founder of climatology, who revolutionized cartography by inventing the first #emph[isothermal maps] around the year 1816; these maps showed areas with similar temperature, variations in altitude and seasons in different colors @hontonForgottenFatherClimatology2022. Humboldt’s isotherms are now available as 3D computer models in @IsothermsSimplyEarth2023.

Earth’s physical systems are very sensitive to small changes in temperature, which was not understood until 30 years ago @mckibbenEndNature2006.

- Industrial revolution: : "transition to a low carbon economy presents challenges and potential economic benefits that are comparable to those of previous industrial revolutions" @pearsonLowCarbonIndustrial2012.
- Tragedy of the commons: @meisingerTragedyIntangibleCommons2022@lopezClimateChangeTimes2022@muraseSevenRulesAvoid2018.

Earth System Models from the first calculation by Svante Arrhenius and Guy Stewart Callendar to today’s complex models that integrate the various Earth systems and cycles ran on supercomputers #cite(<andersonCO2GreenhouseEffect2016>, form: "prose")

=== Climatech
<climatech>
How are large corporations responding to the climate crisis?

Lack of leadership. #cite(<capgeminiWorldBalanceWhy2022>, form: "prose");: "Many business leaders see sustainability as costly obligation rather than investment in the future". #cite(<hoikkalaCEOSeesTerrible2019>, form: "prose");: for example the CEO of the Swedish clothing producer H&M, one of the largest fast-fashion in the world, recognizes the potential impact of conscious consumers as a threat.

Many large businesses have tried to find solutions by launching climate-focused funding. @korosecAmazonTaps2B2021 reports that Amazon’s 2B USD to a Climate Pledge Fund earmarked to fix climate problems is invested in energy, logistics, and packaging startups, which will reduce material waste. "Good intentions don’t work, mechanisms do," Amazon’s founder Bezos is quoted as saying in @cliffordHowThisPopular2022. Walmart is taking a similar approach, having launched a project in 2017 to set CO#sub[2] reduction targets in collaboration with its suppliers #cite(<walmartProjectGigaton2023>, form: "prose");. These examples underlines how money marketed as climate funding by retail conglomerates means focus on reducing operational cost of running their business through automation and material savings.

Large corporations such as Nestle and Coca Cola support the biodiversity law to have a level playing field for business @greensefaNatureVoteSuccess2023.

- #cite(<PublicHealthLinkages2013>, form: "prose")

- #cite(<guidottiHealthSustainabilityIntroduction2015>, form: "prose")

- "Sustainability is important for many reasons including: Environmental Quality –~In order to have healthy communities, we need clean air, natural resources, and a nontoxic environment."

- #cite(<lowRethinkingNetZeroSystems2022>, form: "prose") finds considerable uncertainty exists among experts which CO2 reduction methods among nature-based and technology-based are the most effective.

- Pathways to drawdown

=== Ecosystem Services Enable Life on Earth
<ecosystem-services-enable-life-on-earth>
#cite(<historyEcosystemServices2010>, form: "prose") the history of the valuation of nature’s services goes back to the 18th century when David Ricardo and Jean Baptiste Say discussed nature’s #emph[work];, however both considered it should be free. In 1997 #cite(<dailyNatureServicesSocietal1997>, form: "prose") proposed the idea of ecosystem services and #cite(<costanzaValueWorldEcosystem1997>, form: "prose") attempted to assess the amount of ecosystem services provided.

#cite(<leprovostSupplyMultipleEcosystem2022>, form: "prose") study shows #emph[biodiversity] as one key factor to maintain delivery of ecosystem services. #cite(<noriegaResearchTrendsEcosystem2018>, form: "prose") attempts to quantify the ecosystem services (ES) provided by insects. While it can be assumed much of the flora and fauna are crucial for Earth’s systems, science is still in the process of understanding and quantifying its contributions.

- #cite(<MonetaryValuationNature2023>, form: "prose") should we put a price on nature?
- #cite(<bousfieldCarbonPaymentsCan2022>, form: "prose") reports there’s evidence paying landowners for the ecosystem services their forests provide may reduce deforestation.
- Is it time to leave utilitarian environmentalism behind? #cite(<muradianEcosystemServicesNature2021>, form: "prose")

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    [9 Steps],
    [Identify ecosystem functions],
    [Quantify ecosystem functions],
    [Identify ecosystem services],
    [Quantify ecosystem services],
    [Quantify financial value of ecosystem services],
    [Assign property rights],
    [Create ecosystem service markets],
    [Commodify nature],
  )]
  , caption: [From #cite(<MonetaryValuationNature2023>, form: "prose");]
  , kind: table
  )

There are 2 approaches to protecting nature

#figure(
  align(center)[#table(
    columns: (22.22%, 77.78%),
    align: (auto,auto,),
    [Economics of Nature Commodification], [Economics of the Sacred],
    [Measure and assign value to nature], [Say nature is sacred, such as Churches, and can’t be touched @eisensteinSacredEconomicsMoney2011@eisensteinClimateNewStory2018],
    [], [],
    [], [],
  )]
  , kind: table
  )

- #cite(<hanEmbeddingNaturebasedSolutions2022>, form: "prose") identifies nature-based solutions "land re-naturalization (such as afforestation and wetland restoration)"

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    table.header([Non-Exhaustive list of],),
    table.hline(),
    [Afforestation],
    [Wetland restoration],
    [],
  )]
  , caption: [From #cite(<hanEmbeddingNaturebasedSolutions2022>, form: "prose");]
  , kind: table
  )

- Meanwhile the destruction pressure on ecosystems is rapidly increasing (ADD CITATION A B C).

- #cite(<espinosaImpactsEvolutionChanges2023>, form: "prose") marine ecosystem services #strong[(need access, ncku doesn’t sub)]

- #cite(<chenResponseEcosystemVulnerability2023>, form: "prose") Ecosystem vulnerability #strong[(need access)]

- #cite(<zhangIntegratingEcosystemServices2023>, form: "prose") Integrating ecosystem services conservation into urban planning #strong[(need access)]

- #cite(<liDistinguishingImpactTourism2023>, form: "prose") tourism is a large industrial sector which relies on ecosystem services. In Taiwan, @leeDevelopingIndicatorFramework2021 developed a framework of indicators to assess sustainable tourism.

=== #strong[Environmental Degradation Is Cir]
<environmental-degradation-is-cir>
==== Growing Population and Overpopulation
<growing-population-and-overpopulation>
Earth’s population reached 8 Billion people In November 2022 and population projections by predict 8.5B people by 2030 and 9.7B by 2050 @theeconomictimesClimateChangeEarth2022@unWorldPopulationProspects2022.

@hassounFoodProcessingCurrent2023 forecasts increase of global food demand by 62% including impact of climate change.

- While population growth puts higher pressure on Earth’s resources, some research proposes the effect is more from wasteful lifestyles than the raw number of people @cardinaleBiodiversityLossIts2012.

- #cite(<bowlerMappingHumanPressures2020>, form: "prose") Anthropogenic Threat Complexes (ATCs):

- "Overpopulation is a major cause of biodiversity loss and smaller human populations are necessary to preserve what is left" #cite(<cafaroOverpopulationMajorCause2022>, form: "prose");.

==== Marine Heatwaves
<marine-heatwaves>
- @smaleMarineHeatwavesThreaten2019[ and #cite(<gellesOceanDireMessage2023>, form: "prose");] describe how marine heatwaves threaten global biodiversity.

==== Slavery Still Exists
<slavery-still-exists>
In 2023, an estimated 50 million people are still in slavery around the world; lack of supply chain visibility hides forced labor and exploitation of undocumented migrants in agricultural work; 71% of enslaved people are estimated to be women. @kunzAdoptionTransferabilityJoint2023@borrelliCareSupportMaternity2023.

The UN SDG target 8.7 targets to eliminate all forms of slavery.

Slavery is connected to environmental degradation and climate change @deckersparksGrowingEvidenceInterconnections2021. Enslaved people are used in environmental crimes such as 40% of deforestation globally. Cobalt used in technological products is in risk of being produced under forced labor in the D.R. Congo @sovacoolWhenSubterraneanSlavery2021. In India and Pakistan, forced labor in brick kiln farms is possible to capture remotely from satellite images @boydSlaverySpaceDemonstrating2018. In effect, the need for cheap labor turns slavery into a #emph[subsidy] keeping environmental degradation happening.

- #cite(<christBlockchainTechnologyModern2021>, form: "prose") estimates 20 million people are stuck inside corporate blockchains. The Global Slavery Index measures the #strong[#emph[Import Risk];] of having slavery inside its imports #cite(<walkfreeGlobalSlaveryIndex2023>, form: "prose");.

- #cite(<hansvanleeuwenModernSlaveryGrace2023>, form: "prose") slavery affects industries from fashion to technology, including sustainability enablers such as solar panels.

- "commodification of human beings"

- #cite(<anandchandrasekharWhySwitzerlandMatters2021>, form: "prose");: Trading commodities "Switzerland has a hand in over 50% of the global trade in coffee and vegetable oils like palm oil as well as 35% of the global volume of cocoa, according to government estimates." Can traders have more scrutiny over what they trade?

- Modern Slavery Act.

==== Overconsumption Drive Climate Change
<overconsumption-drive-climate-change>
Overconsumption is one of the main drivers of climate change.” Around 2/3 of global GHG emissions are directly and indirectly linked to household consumption, with a global average of about 6 tonnes CO#sub[2] equivalent per capita.” @reneechoHowBuyingStuff2020@ivanovaQuantifyingPotentialClimate2020

Overconsumption is also one of the root causes of plastic pollution. #cite(<FORD2022150392>, form: "prose") and #cite(<laversFarDistractionPlastic2022>, form: "prose") find strong linkage of climate change and marine plastic pollution "along with other stressors that threaten the resilience of species and habitats sensitive to both climate change and plastic pollution".

- #cite(<laversFarDistractionPlastic2022>, form: "prose") plastic pollution is pervasive around the Earth and is fundamentally linked to climate change

While the number on overconsumption are clear, the debate on overconsumption is so polarized, it’s difficult to have a meaningful discussion of the topic @ianoleOverconsumptionSocietyLookingglass2013.

- Overconsumption and underinvestment.

- Cities are responsible for 80% of the emissions #cite(<rosalescarreonUrbanEnergySystems2018>, form: "prose")

- #cite(<mobergMobilityFoodHousing2019>, form: "prose") reports daily human activities emission contribution on average in four European countries (France, Germany, Norway and Sweden).

#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (auto,auto,),
    [Emission Share], [Category],
    [21%], [Housing],
    [30%], [Food],
    [34%], [Mobility],
    [15%], [Other],
  )]
  , caption: [Daily human activities emission contribution on average in France, Germany, Norway and Sweden from #cite(<mobergMobilityFoodHousing2019>, form: "prose");.]
  , kind: table
  )

- #cite(<eestivabariigivalitsusRohepoordeTegevusplaan2022>, form: "prose") Estonian Green Deal Action Plan (Eesti Rohepöörde Tegevusplaan).
- #cite(<armstrongmckayExceedingGlobalWarming2022>, form: "prose") discusses tipping points.

=== Earth System Law
<earth-system-law>
- #cite(<dutoitReimaginingInternationalEnvironmental2022>, form: "prose") describes Earth System Law as a framework for addressing interconnected environmental challenges.

- #cite(<williamsIntensificationWinterTransatlantic2013>, form: "prose") higher CO#sub[2] concentrations in the air can cause more turbulence for flights.

- Warmer climate helps viruses and fungi spread #cite(<pressFungalDiseaseRapidly2023>, form: "prose")

=== Biodiversity is Decreasing Rapidly
<biodiversity-is-decreasing-rapidly>
#cite(<livingPlanetReport2022>, form: "prose") reported, the number of species killed, mass destruction of nature. "69% decline in the relative abundance of monitored wildlife populations around the world between 1970 and 2018. Latin America shows the greatest regional decline in average population abundance (94%), while freshwater species populations have seen the greatest overall global decline (83%)."

#block[
```
FileNotFoundError: [Errno 2] No such file or directory: '/Users/krishaamer/Desktop/current/thesis/green-filter-research/research/fonts/notosans.ttf'
[0;31m---------------------------------------------------------------------------[0m
[0;31mFileNotFoundError[0m                         Traceback (most recent call last)
File [0;32m~/anaconda3/lib/python3.10/site-packages/IPython/core/formatters.py:338[0m, in [0;36mBaseFormatter.__call__[0;34m(self, obj)[0m
[1;32m    336[0m     [38;5;28;01mpass[39;00m
[1;32m    337[0m [38;5;28;01melse[39;00m:
[0;32m--> 338[0m     [38;5;28;01mreturn[39;00m [43mprinter[49m[43m([49m[43mobj[49m[43m)[49m
[1;32m    339[0m [38;5;66;03m# Finally look for special method names[39;00m
[1;32m    340[0m method [38;5;241m=[39m get_real_method(obj, [38;5;28mself[39m[38;5;241m.[39mprint_method)

File [0;32m~/anaconda3/lib/python3.10/site-packages/IPython/core/pylabtools.py:152[0m, in [0;36mprint_figure[0;34m(fig, fmt, bbox_inches, base64, **kwargs)[0m
[1;32m    149[0m     [38;5;28;01mfrom[39;00m [38;5;21;01mmatplotlib[39;00m[38;5;21;01m.[39;00m[38;5;21;01mbackend_bases[39;00m [38;5;28;01mimport[39;00m FigureCanvasBase
[1;32m    150[0m     FigureCanvasBase(fig)
[0;32m--> 152[0m [43mfig[49m[38;5;241;43m.[39;49m[43mcanvas[49m[38;5;241;43m.[39;49m[43mprint_figure[49m[43m([49m[43mbytes_io[49m[43m,[49m[43m [49m[38;5;241;43m*[39;49m[38;5;241;43m*[39;49m[43mkw[49m[43m)[49m
[1;32m    153[0m data [38;5;241m=[39m bytes_io[38;5;241m.[39mgetvalue()
[1;32m    154[0m [38;5;28;01mif[39;00m fmt [38;5;241m==[39m [38;5;124m'[39m[38;5;124msvg[39m[38;5;124m'[39m:

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/backend_bases.py:2164[0m, in [0;36mFigureCanvasBase.print_figure[0;34m(self, filename, dpi, facecolor, edgecolor, orientation, format, bbox_inches, pad_inches, bbox_extra_artists, backend, **kwargs)[0m
[1;32m   2161[0m     [38;5;66;03m# we do this instead of `self.figure.draw_without_rendering`[39;00m
[1;32m   2162[0m     [38;5;66;03m# so that we can inject the orientation[39;00m
[1;32m   2163[0m     [38;5;28;01mwith[39;00m [38;5;28mgetattr[39m(renderer, [38;5;124m"[39m[38;5;124m_draw_disabled[39m[38;5;124m"[39m, nullcontext)():
[0;32m-> 2164[0m         [38;5;28;43mself[39;49m[38;5;241;43m.[39;49m[43mfigure[49m[38;5;241;43m.[39;49m[43mdraw[49m[43m([49m[43mrenderer[49m[43m)[49m
[1;32m   2165[0m [38;5;28;01mif[39;00m bbox_inches:
[1;32m   2166[0m     [38;5;28;01mif[39;00m bbox_inches [38;5;241m==[39m [38;5;124m"[39m[38;5;124mtight[39m[38;5;124m"[39m:

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/artist.py:95[0m, in [0;36m_finalize_rasterization.<locals>.draw_wrapper[0;34m(artist, renderer, *args, **kwargs)[0m
[1;32m     93[0m [38;5;129m@wraps[39m(draw)
[1;32m     94[0m [38;5;28;01mdef[39;00m [38;5;21mdraw_wrapper[39m(artist, renderer, [38;5;241m*[39margs, [38;5;241m*[39m[38;5;241m*[39mkwargs):
[0;32m---> 95[0m     result [38;5;241m=[39m [43mdraw[49m[43m([49m[43martist[49m[43m,[49m[43m [49m[43mrenderer[49m[43m,[49m[43m [49m[38;5;241;43m*[39;49m[43margs[49m[43m,[49m[43m [49m[38;5;241;43m*[39;49m[38;5;241;43m*[39;49m[43mkwargs[49m[43m)[49m
[1;32m     96[0m     [38;5;28;01mif[39;00m renderer[38;5;241m.[39m_rasterizing:
[1;32m     97[0m         renderer[38;5;241m.[39mstop_rasterizing()

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/artist.py:72[0m, in [0;36mallow_rasterization.<locals>.draw_wrapper[0;34m(artist, renderer)[0m
[1;32m     69[0m     [38;5;28;01mif[39;00m artist[38;5;241m.[39mget_agg_filter() [38;5;129;01mis[39;00m [38;5;129;01mnot[39;00m [38;5;28;01mNone[39;00m:
[1;32m     70[0m         renderer[38;5;241m.[39mstart_filter()
[0;32m---> 72[0m     [38;5;28;01mreturn[39;00m [43mdraw[49m[43m([49m[43martist[49m[43m,[49m[43m [49m[43mrenderer[49m[43m)[49m
[1;32m     73[0m [38;5;28;01mfinally[39;00m:
[1;32m     74[0m     [38;5;28;01mif[39;00m artist[38;5;241m.[39mget_agg_filter() [38;5;129;01mis[39;00m [38;5;129;01mnot[39;00m [38;5;28;01mNone[39;00m:

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/figure.py:3154[0m, in [0;36mFigure.draw[0;34m(self, renderer)[0m
[1;32m   3151[0m         [38;5;66;03m# ValueError can occur when resizing a window.[39;00m
[1;32m   3153[0m [38;5;28mself[39m[38;5;241m.[39mpatch[38;5;241m.[39mdraw(renderer)
[0;32m-> 3154[0m [43mmimage[49m[38;5;241;43m.[39;49m[43m_draw_list_compositing_images[49m[43m([49m
[1;32m   3155[0m [43m    [49m[43mrenderer[49m[43m,[49m[43m [49m[38;5;28;43mself[39;49m[43m,[49m[43m [49m[43martists[49m[43m,[49m[43m [49m[38;5;28;43mself[39;49m[38;5;241;43m.[39;49m[43msuppressComposite[49m[43m)[49m
[1;32m   3157[0m [38;5;28;01mfor[39;00m sfig [38;5;129;01min[39;00m [38;5;28mself[39m[38;5;241m.[39msubfigs:
[1;32m   3158[0m     sfig[38;5;241m.[39mdraw(renderer)

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/image.py:132[0m, in [0;36m_draw_list_compositing_images[0;34m(renderer, parent, artists, suppress_composite)[0m
[1;32m    130[0m [38;5;28;01mif[39;00m not_composite [38;5;129;01mor[39;00m [38;5;129;01mnot[39;00m has_images:
[1;32m    131[0m     [38;5;28;01mfor[39;00m a [38;5;129;01min[39;00m artists:
[0;32m--> 132[0m         [43ma[49m[38;5;241;43m.[39;49m[43mdraw[49m[43m([49m[43mrenderer[49m[43m)[49m
[1;32m    133[0m [38;5;28;01melse[39;00m:
[1;32m    134[0m     [38;5;66;03m# Composite any adjacent images together[39;00m
[1;32m    135[0m     image_group [38;5;241m=[39m []

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/artist.py:72[0m, in [0;36mallow_rasterization.<locals>.draw_wrapper[0;34m(artist, renderer)[0m
[1;32m     69[0m     [38;5;28;01mif[39;00m artist[38;5;241m.[39mget_agg_filter() [38;5;129;01mis[39;00m [38;5;129;01mnot[39;00m [38;5;28;01mNone[39;00m:
[1;32m     70[0m         renderer[38;5;241m.[39mstart_filter()
[0;32m---> 72[0m     [38;5;28;01mreturn[39;00m [43mdraw[49m[43m([49m[43martist[49m[43m,[49m[43m [49m[43mrenderer[49m[43m)[49m
[1;32m     73[0m [38;5;28;01mfinally[39;00m:
[1;32m     74[0m     [38;5;28;01mif[39;00m artist[38;5;241m.[39mget_agg_filter() [38;5;129;01mis[39;00m [38;5;129;01mnot[39;00m [38;5;28;01mNone[39;00m:

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/axes/_base.py:3070[0m, in [0;36m_AxesBase.draw[0;34m(self, renderer)[0m
[1;32m   3067[0m [38;5;28;01mif[39;00m artists_rasterized:
[1;32m   3068[0m     _draw_rasterized([38;5;28mself[39m[38;5;241m.[39mfigure, artists_rasterized, renderer)
[0;32m-> 3070[0m [43mmimage[49m[38;5;241;43m.[39;49m[43m_draw_list_compositing_images[49m[43m([49m
[1;32m   3071[0m [43m    [49m[43mrenderer[49m[43m,[49m[43m [49m[38;5;28;43mself[39;49m[43m,[49m[43m [49m[43martists[49m[43m,[49m[43m [49m[38;5;28;43mself[39;49m[38;5;241;43m.[39;49m[43mfigure[49m[38;5;241;43m.[39;49m[43msuppressComposite[49m[43m)[49m
[1;32m   3073[0m renderer[38;5;241m.[39mclose_group([38;5;124m'[39m[38;5;124maxes[39m[38;5;124m'[39m)
[1;32m   3074[0m [38;5;28mself[39m[38;5;241m.[39mstale [38;5;241m=[39m [38;5;28;01mFalse[39;00m

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/image.py:132[0m, in [0;36m_draw_list_compositing_images[0;34m(renderer, parent, artists, suppress_composite)[0m
[1;32m    130[0m [38;5;28;01mif[39;00m not_composite [38;5;129;01mor[39;00m [38;5;129;01mnot[39;00m has_images:
[1;32m    131[0m     [38;5;28;01mfor[39;00m a [38;5;129;01min[39;00m artists:
[0;32m--> 132[0m         [43ma[49m[38;5;241;43m.[39;49m[43mdraw[49m[43m([49m[43mrenderer[49m[43m)[49m
[1;32m    133[0m [38;5;28;01melse[39;00m:
[1;32m    134[0m     [38;5;66;03m# Composite any adjacent images together[39;00m
[1;32m    135[0m     image_group [38;5;241m=[39m []

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/artist.py:72[0m, in [0;36mallow_rasterization.<locals>.draw_wrapper[0;34m(artist, renderer)[0m
[1;32m     69[0m     [38;5;28;01mif[39;00m artist[38;5;241m.[39mget_agg_filter() [38;5;129;01mis[39;00m [38;5;129;01mnot[39;00m [38;5;28;01mNone[39;00m:
[1;32m     70[0m         renderer[38;5;241m.[39mstart_filter()
[0;32m---> 72[0m     [38;5;28;01mreturn[39;00m [43mdraw[49m[43m([49m[43martist[49m[43m,[49m[43m [49m[43mrenderer[49m[43m)[49m
[1;32m     73[0m [38;5;28;01mfinally[39;00m:
[1;32m     74[0m     [38;5;28;01mif[39;00m artist[38;5;241m.[39mget_agg_filter() [38;5;129;01mis[39;00m [38;5;129;01mnot[39;00m [38;5;28;01mNone[39;00m:

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/text.py:748[0m, in [0;36mText.draw[0;34m(self, renderer)[0m
[1;32m    745[0m renderer[38;5;241m.[39mopen_group([38;5;124m'[39m[38;5;124mtext[39m[38;5;124m'[39m, [38;5;28mself[39m[38;5;241m.[39mget_gid())
[1;32m    747[0m [38;5;28;01mwith[39;00m [38;5;28mself[39m[38;5;241m.[39m_cm_set(text[38;5;241m=[39m[38;5;28mself[39m[38;5;241m.[39m_get_wrapped_text()):
[0;32m--> 748[0m     bbox, info, descent [38;5;241m=[39m [38;5;28;43mself[39;49m[38;5;241;43m.[39;49m[43m_get_layout[49m[43m([49m[43mrenderer[49m[43m)[49m
[1;32m    749[0m     trans [38;5;241m=[39m [38;5;28mself[39m[38;5;241m.[39mget_transform()
[1;32m    751[0m     [38;5;66;03m# don't use self.get_position here, which refers to text[39;00m
[1;32m    752[0m     [38;5;66;03m# position in Text:[39;00m

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/text.py:373[0m, in [0;36mText._get_layout[0;34m(self, renderer)[0m
[1;32m    370[0m ys [38;5;241m=[39m []
[1;32m    372[0m [38;5;66;03m# Full vertical extent of font, including ascenders and descenders:[39;00m
[0;32m--> 373[0m _, lp_h, lp_d [38;5;241m=[39m [43m_get_text_metrics_with_cache[49m[43m([49m
[1;32m    374[0m [43m    [49m[43mrenderer[49m[43m,[49m[43m [49m[38;5;124;43m"[39;49m[38;5;124;43mlp[39;49m[38;5;124;43m"[39;49m[43m,[49m[43m [49m[38;5;28;43mself[39;49m[38;5;241;43m.[39;49m[43m_fontproperties[49m[43m,[49m
[1;32m    375[0m [43m    [49m[43mismath[49m[38;5;241;43m=[39;49m[38;5;124;43m"[39;49m[38;5;124;43mTeX[39;49m[38;5;124;43m"[39;49m[43m [49m[38;5;28;43;01mif[39;49;00m[43m [49m[38;5;28;43mself[39;49m[38;5;241;43m.[39;49m[43mget_usetex[49m[43m([49m[43m)[49m[43m [49m[38;5;28;43;01melse[39;49;00m[43m [49m[38;5;28;43;01mFalse[39;49;00m[43m,[49m[43m [49m[43mdpi[49m[38;5;241;43m=[39;49m[38;5;28;43mself[39;49m[38;5;241;43m.[39;49m[43mfigure[49m[38;5;241;43m.[39;49m[43mdpi[49m[43m)[49m
[1;32m    376[0m min_dy [38;5;241m=[39m (lp_h [38;5;241m-[39m lp_d) [38;5;241m*[39m [38;5;28mself[39m[38;5;241m.[39m_linespacing
[1;32m    378[0m [38;5;28;01mfor[39;00m i, line [38;5;129;01min[39;00m [38;5;28menumerate[39m(lines):

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/text.py:69[0m, in [0;36m_get_text_metrics_with_cache[0;34m(renderer, text, fontprop, ismath, dpi)[0m
[1;32m     66[0m [38;5;124;03m"""Call ``renderer.get_text_width_height_descent``, caching the results."""[39;00m
[1;32m     67[0m [38;5;66;03m# Cached based on a copy of fontprop so that later in-place mutations of[39;00m
[1;32m     68[0m [38;5;66;03m# the passed-in argument do not mess up the cache.[39;00m
[0;32m---> 69[0m [38;5;28;01mreturn[39;00m [43m_get_text_metrics_with_cache_impl[49m[43m([49m
[1;32m     70[0m [43m    [49m[43mweakref[49m[38;5;241;43m.[39;49m[43mref[49m[43m([49m[43mrenderer[49m[43m)[49m[43m,[49m[43m [49m[43mtext[49m[43m,[49m[43m [49m[43mfontprop[49m[38;5;241;43m.[39;49m[43mcopy[49m[43m([49m[43m)[49m[43m,[49m[43m [49m[43mismath[49m[43m,[49m[43m [49m[43mdpi[49m[43m)[49m

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/text.py:77[0m, in [0;36m_get_text_metrics_with_cache_impl[0;34m(renderer_ref, text, fontprop, ismath, dpi)[0m
[1;32m     73[0m [38;5;129m@functools[39m[38;5;241m.[39mlru_cache([38;5;241m4096[39m)
[1;32m     74[0m [38;5;28;01mdef[39;00m [38;5;21m_get_text_metrics_with_cache_impl[39m(
[1;32m     75[0m         renderer_ref, text, fontprop, ismath, dpi):
[1;32m     76[0m     [38;5;66;03m# dpi is unused, but participates in cache invalidation (via the renderer).[39;00m
[0;32m---> 77[0m     [38;5;28;01mreturn[39;00m [43mrenderer_ref[49m[43m([49m[43m)[49m[38;5;241;43m.[39;49m[43mget_text_width_height_descent[49m[43m([49m[43mtext[49m[43m,[49m[43m [49m[43mfontprop[49m[43m,[49m[43m [49m[43mismath[49m[43m)[49m

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/backends/backend_svg.py:1287[0m, in [0;36mRendererSVG.get_text_width_height_descent[0;34m(self, s, prop, ismath)[0m
[1;32m   1285[0m [38;5;28;01mdef[39;00m [38;5;21mget_text_width_height_descent[39m([38;5;28mself[39m, s, prop, ismath):
[1;32m   1286[0m     [38;5;66;03m# docstring inherited[39;00m
[0;32m-> 1287[0m     [38;5;28;01mreturn[39;00m [38;5;28;43mself[39;49m[38;5;241;43m.[39;49m[43m_text2path[49m[38;5;241;43m.[39;49m[43mget_text_width_height_descent[49m[43m([49m[43ms[49m[43m,[49m[43m [49m[43mprop[49m[43m,[49m[43m [49m[43mismath[49m[43m)[49m

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/textpath.py:63[0m, in [0;36mTextToPath.get_text_width_height_descent[0;34m(self, s, prop, ismath)[0m
[1;32m     59[0m     width, height, descent, [38;5;241m*[39m_ [38;5;241m=[39m \
[1;32m     60[0m         [38;5;28mself[39m[38;5;241m.[39mmathtext_parser[38;5;241m.[39mparse(s, [38;5;241m72[39m, prop)
[1;32m     61[0m     [38;5;28;01mreturn[39;00m width [38;5;241m*[39m scale, height [38;5;241m*[39m scale, descent [38;5;241m*[39m scale
[0;32m---> 63[0m font [38;5;241m=[39m [38;5;28;43mself[39;49m[38;5;241;43m.[39;49m[43m_get_font[49m[43m([49m[43mprop[49m[43m)[49m
[1;32m     64[0m font[38;5;241m.[39mset_text(s, [38;5;241m0.0[39m, flags[38;5;241m=[39mLOAD_NO_HINTING)
[1;32m     65[0m w, h [38;5;241m=[39m font[38;5;241m.[39mget_width_height()

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/textpath.py:35[0m, in [0;36mTextToPath._get_font[0;34m(self, prop)[0m
[1;32m     31[0m [38;5;124;03m"""[39;00m
[1;32m     32[0m [38;5;124;03mFind the `FT2Font` matching font properties *prop*, with its size set.[39;00m
[1;32m     33[0m [38;5;124;03m"""[39;00m
[1;32m     34[0m filenames [38;5;241m=[39m _fontManager[38;5;241m.[39m_find_fonts_by_props(prop)
[0;32m---> 35[0m font [38;5;241m=[39m [43mget_font[49m[43m([49m[43mfilenames[49m[43m)[49m
[1;32m     36[0m font[38;5;241m.[39mset_size([38;5;28mself[39m[38;5;241m.[39mFONT_SCALE, [38;5;28mself[39m[38;5;241m.[39mDPI)
[1;32m     37[0m [38;5;28;01mreturn[39;00m font

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/font_manager.py:1554[0m, in [0;36mget_font[0;34m(font_filepaths, hinting_factor)[0m
[1;32m   1551[0m [38;5;28;01mif[39;00m hinting_factor [38;5;129;01mis[39;00m [38;5;28;01mNone[39;00m:
[1;32m   1552[0m     hinting_factor [38;5;241m=[39m mpl[38;5;241m.[39mrcParams[[38;5;124m'[39m[38;5;124mtext.hinting_factor[39m[38;5;124m'[39m]
[0;32m-> 1554[0m [38;5;28;01mreturn[39;00m [43m_get_font[49m[43m([49m
[1;32m   1555[0m [43m    [49m[38;5;66;43;03m# must be a tuple to be cached[39;49;00m
[1;32m   1556[0m [43m    [49m[43mpaths[49m[43m,[49m
[1;32m   1557[0m [43m    [49m[43mhinting_factor[49m[43m,[49m
[1;32m   1558[0m [43m    [49m[43m_kerning_factor[49m[38;5;241;43m=[39;49m[43mmpl[49m[38;5;241;43m.[39;49m[43mrcParams[49m[43m[[49m[38;5;124;43m'[39;49m[38;5;124;43mtext.kerning_factor[39;49m[38;5;124;43m'[39;49m[43m][49m[43m,[49m
[1;32m   1559[0m [43m    [49m[38;5;66;43;03m# also key on the thread ID to prevent segfaults with multi-threading[39;49;00m
[1;32m   1560[0m [43m    [49m[43mthread_id[49m[38;5;241;43m=[39;49m[43mthreading[49m[38;5;241;43m.[39;49m[43mget_ident[49m[43m([49m[43m)[49m
[1;32m   1561[0m [43m[49m[43m)[49m

File [0;32m~/anaconda3/lib/python3.10/site-packages/matplotlib/font_manager.py:1496[0m, in [0;36m_get_font[0;34m(font_filepaths, hinting_factor, _kerning_factor, thread_id)[0m
[1;32m   1493[0m [38;5;129m@lru_cache[39m([38;5;241m64[39m)
[1;32m   1494[0m [38;5;28;01mdef[39;00m [38;5;21m_get_font[39m(font_filepaths, hinting_factor, [38;5;241m*[39m, _kerning_factor, thread_id):
[1;32m   1495[0m     first_fontpath, [38;5;241m*[39mrest [38;5;241m=[39m font_filepaths
[0;32m-> 1496[0m     [38;5;28;01mreturn[39;00m [43mft2font[49m[38;5;241;43m.[39;49m[43mFT2Font[49m[43m([49m
[1;32m   1497[0m [43m        [49m[43mfirst_fontpath[49m[43m,[49m[43m [49m[43mhinting_factor[49m[43m,[49m
[1;32m   1498[0m [43m        [49m[43m_fallback_list[49m[38;5;241;43m=[39;49m[43m[[49m
[1;32m   1499[0m [43m            [49m[43mft2font[49m[38;5;241;43m.[39;49m[43mFT2Font[49m[43m([49m
[1;32m   1500[0m [43m                [49m[43mfpath[49m[43m,[49m[43m [49m[43mhinting_factor[49m[43m,[49m
[1;32m   1501[0m [43m                [49m[43m_kerning_factor[49m[38;5;241;43m=[39;49m[43m_kerning_factor[49m
[1;32m   1502[0m [43m            [49m[43m)[49m
[1;32m   1503[0m [43m            [49m[38;5;28;43;01mfor[39;49;00m[43m [49m[43mfpath[49m[43m [49m[38;5;129;43;01min[39;49;00m[43m [49m[43mrest[49m
[1;32m   1504[0m [43m        [49m[43m][49m[43m,[49m
[1;32m   1505[0m [43m        [49m[43m_kerning_factor[49m[38;5;241;43m=[39;49m[43m_kerning_factor[49m
[1;32m   1506[0m [43m    [49m[43m)[49m

[0;31mFileNotFoundError[0m: [Errno 2] No such file or directory: '/Users/krishaamer/Desktop/current/thesis/green-filter-research/research/fonts/notosans.ttf'
```

]
```
<Figure size 960x576 with 1 Axes>
```

Biodiversity loss is linked to overconsumption, weak legislation and lack of oversight. @crennaBiodiversityImpactsDue2019 recounts European Union consumers’ negative impact on biodiversity in countries where it imports food. #cite(<wwfForestsReducingEU2022>, form: "prose") case study highlights how 4 biodiverse regions Cerrado in Brazil, Chaco in Argentina, Sumatra in Indonesia, and the Cuvette Centrale in Democratic Republic of Congo are experiencing rapid destruction due to consumer demand in the European Union. While the European Union (EU) has recently become a leader in sustainability legislation, biodiversity protection measures among private companies is very low #cite(<marco-fondevilaTrendsPrivateSector2023>, form: "prose");.

Meanwhile, there is some progress in biodiversity conservation. #cite(<uebtBiodiversityBarometer2022>, form: "prose") reports "Biodiversity awareness is now at 72% or higher in all countries sampled, compared to only 29% or higher across countries sampled in 2009."

Similarly to climate protection, the UN has taken a leadership role in biodiversity protection. #cite(<unitHistoryConvention2023>, form: "prose");: The history of the United Nations Convention on Biodiversity goes back to 1988, when the working group was founded. #cite(<unepCOP15EndsLandmark2022>, form: "prose");: The Convention on Biodiversity 2022 (COP15) adopted the first global biodiversity framework to accompany climate goals.

==== #strong[#emph[Biodiversity Indicators];]
<biodiversity-indicators>
Cutting edge research uses AI for listening to nature, assessing biodiversity based on species’ sounds in the forest. Millions of detections of different species with machine learning passive acoustic AI models, can also assess species response to climate change @aiforgoodListeningNatureHarnessing2023@guerreroAcousticAnimalIdentification2023.

#cite(<mayWhyShouldWe2011>, form: "prose") argues biodiversity loss is a concern for 3 points of views:

#figure(
  align(center)[#table(
    columns: (20.72%, 79.28%),
    align: (auto,auto,),
    [View], [],
    [Narrowly Utilitarian], [Biodiversity is a resource of genetic novelties for the biotech industry.],
    [Broadly Utilitarian], [Humans depend upon biodiverse ecosystems.],
    [Ethical], [Humans have a responsibility to future generations to pass down a rich natural world.],
  )]
  , caption: [From #cite(<mayWhyShouldWe2011>, form: "prose");.]
  , kind: table
  )

==== Forest and Deforestion
<forest-and-deforestion>
Around 27% of Earth’s land area is still covered by forests yet deforestation is widespread all around the world; highest rates of deforestation happened in the tropical rainforests of South America and Africa, mainly caused by agricultural cropland expansion (50% of all deforestation) and grazing land for farm animals to produce meat (38,5%), totaling close to 90% of global deforestation @FRA2020Remote2022. Forests are a crucial part of Earth’s carbon cycle and the main natural CO#sub[2] capture system; due to deforestation, Europe rapidly losing its forest carbon sink @fredericsimonEuropeRapidlyLosing2022.

Afforestation is different from reforestation, which takes into account biodiversity.

- #cite(<klostermanMappingGlobalPotential2022>, form: "prose") using remote-sensing and machine-learning to assess reforestation potential; doesn’t take into account political realities.

- Global Forest Cover Change, Earth Engine #cite(<hansenHighResolutionGlobalMaps2013>, form: "prose")

- 1 billion tree project @greenfieldVeNeverSaid2021@ErratumReportGlobal2020@bastinGlobalTreeRestoration2019

- Burning of biomass undermines carbon capture.

==== Air and Water Pollution is Widespread
<air-and-water-pollution-is-widespread>
- Clean water and water pollution
- #cite(<kochOpinionArizonaRace2022>, form: "prose") (#strong[Need access! nyc times)]

Air pollution is widespread around the planet, with 99% of Earth’s human population being affected by bad air quality that does not meet WHO air quality guidelines, leading to health problems linked to 6.7 million premature deaths every year #cite(<worldhealthorganizationAmbientOutdoorAir2022>, form: "prose");. Grounbreaking research by #cite(<lim1MOAirPollutioninduced2022>, form: "prose") analyzed over 400000 individuals in England, South Korea and Taiwan establishes exposure to 2.5μm PM (PM2.5) air pollution as a cause for lung cancer. #cite(<bouscasseDesigningLocalAir2022>, form: "prose") finds strong health and economic benefits across the board from air pollution reduction in France. In #cite(<hannahdevlinCancerBreakthroughWakeup2022>, form: "prose");, prof Tony Mok, of the Chinese University of Hong Kong: "We have known about the link between pollution and lung cancer for a long time, and we now have a possible explanation for it. As consumption of fossil fuels goes hand in hand with pollution and carbon emissions, we have a strong mandate for tackling these issues – for both environmental and health reasons".

Health and sustainability are inextricably linked. "Human health is central to all sustainability efforts.", "All of these (food, housing, power, and health care), and the~stress~that the lack of them generate, play a huge role in our health" @sarahludwigrauschSustainabilityYourHealth2021.

The main way to combat air pollution is through policy interventions. #cite(<marialuisfernandesRealityCheckIndustrial2023>, form: "prose") EU has legislation in progress to curb industrial emissions. If legislation is in place, causing bad air quality can become bad for business. #cite(<guHiddenCostsNongreen2023>, form: "prose") links air pollution to credit interest rates for business loans in China; companies with low environmetal awareness and a history of environmental penalties pay 12 percent higher interest rates.

Clean air is a requirement.

==== Climate Change Disasters
<climate-change-disasters>
- A comprehensive review of evidence from paleoclimate records until current time, including ocean, atmosphere, and land surface of points towards substantial climate change if high levels of greenhouse gas emissions continue, termed by the authors as #emph[climate sensitivity] @sherwoodAssessmentEarthClimate2020.

- @FifthNationalClimate2023 The US Global Change Research Program comprehensive report to the US Congress links disaster-risk directly to global warming; for examples increased wildfires damage property, endager life and reduces air quality, which in effect increases health challenges.

Environmental activists have been calling attention to global warming for decades, yet the world has been slow to act @mckibbenEndNature1989.

- Flood risk mapping might lower property prices in at risk areas @sherrenFloodRiskMapping2024.

- In Taiwan disaster risk and hazard mapping, early warning systems, and comprehensive response save lives #cite(<tsaiFrameworkEmergencyResponse2021>, form: "prose")

Global warming increases the risk of disasters and extreme weather events. As extreme temperatures are increasingly commonplace, there’s increased risk of wildfires @volkovaEffectsPrescribedFire2021. Summers of 2022 and 2023 were the hottest on record so far, with extreme heat waves recorded in places around the world @venturelliHighTemperatureCOVID192023@serrano-notivoliUnprecedentedWarmthLook2023@douglasThisSummerTrack2023@EarthJustHad2023@NOAAJune2023@falconer123MillionHeat2023. As temperatures rise, certain cities may become uninhabitable for humans @cbcradioExtremeHeatCould2021. The summer of 2023 saw extensive wildfires in Spain, Canada, and elsewhere; rapidly moving fires destroyed the whole city of Lāhainā in Hawaii \[ADD CITATION\]. The part of Earth where the #emph[human climate niche] is becoming smaller @mckibbenWhereShouldLive2023. Some parts of South America have seen summer heat in the winter, with heatwaves with temperatures as high as 38 degrees @livingstonItMidwinterIt2023.

- Observed changes in heatwaves @perkins-kirkpatrickExtremeHeatClimate2023.
- Word Economic Forums Global Risks Report 2024 paints a bleak picture of the future with expectations of increased turbulence across the board based on a survey of over 1400 topic experts #cite(<worldeconomicforumGlobalRisksReport>, form: "prose")

Climate-related disasters can spur action as extreme weather becomes visible to everyone. After large floods in South Korea in July 2023 with many victims, president Joon promised to begin taking global warming seriously and steer the country towards climate action #cite(<webSouthKoreaPresident2023>, form: "prose");; #cite(<afpKoreaPresidentVows2023>, form: "prose");; #cite(<aljazeeraDeathTollKorea2023>, form: "prose");. South Korea has a partnership with the European Union #cite(<europeancommissionEURepublicKorea2023>, form: "prose");.

The fossil energy production that’s a large part of global CO2 emissions has caused several high-profile pollution events. Large ones that got international news coverage include Exxon Valdez and Deepwater Horizon.

- Chernobyl and Fukushima
- the Great Pacific Garbage Patch
- #cite(<lentonQuantifyingHumanCost2023>, form: "prose") quantifying human cost of global warming.
- EJAtlas tracks environmental justice cases around the world @martinez-alierMappingEcologicalDistribution2021[ and #cite(<martinez-alierReplyOrihuelaExtractivism2022>, form: "prose") as well as #cite(<scheidelEnvironmentalConflictsDefenders2020>, form: "prose");];.
- Disputes in #cite(<eerolaCorporateConductCommodity2022>, form: "prose");.

==== Carbon Accounting in Corporate Industry
<carbon-accounting-in-corporate-industry>
- Watershed

- The legislation has created an industry of CO#sub[2] accounting with many companies like Greenly, Sustaxo, etc.

- #cite(<quatriniChallengesOpportunitiesScale2021>, form: "prose") sustainability assessments are complex and may give flawed results.

- Nonetheles, CO#sub[2] emission reduction has the added positive effect of boosting corporate morale @caoImpactLoweringCarbon2023.

=== Agroforestry & Permaculture
<agroforestry-permaculture>
- Agroecology #cite(<balticseaactiongroupEITFoodRegenerative2023>, form: "prose")

Agroforestry plays an active role in achieving Sustainable Development Goals (SDGs) @rubaPotentialityHomesteadAgroforestry2023;

- Food forests for regenerative food systems.

- #cite(<irwinIncreasingTreeCover2023>, form: "prose")

- #cite(<yadavExploringInnovationSustainable2023>, form: "prose")

- #cite(<lowMixedFarmingAgroforestry2023>, form: "prose")

- #cite(<ollinahoSeparatingTwoFaces2023>, form: "prose") "bioeconomy is not inherently sustainable and may pose considerable risks to biodiversity."

- #cite(<dequeiroz-steinPossibilitiesMainstreamingBiodiversity2023>, form: "prose")

- #cite(<gamageRoleOrganicFarming2023>, form: "prose") "Organic food and drink sales in 2019 totaled more than 106 billion euros worldwide."

- "Would you rather buy a DogeCoin or a regenerative food forest token?" Curve Labs founder Pat Rawson quotes #cite(<shillerNarrativeEconomicsHow2019>, form: "prose") in ReFi podcast about Kolektivo. #cite(<refidaoReFiPodcastS2E92022>, form: "prose") (Use as a question for the survey?)

=== Quality of Life
<quality-of-life>
- #cite(<kaklauskasSynergyClimateChange2023>, form: "prose")

- #cite(<riegerIntegratedScienceWellbeing2023>, form: "prose") Integrated science of wellbeing

- #cite(<fabrisCLIMATECHANGEQUALITY2022>, form: "prose")

- Sustainability is part of product quality. If a product is hurting the environment, it’s a low quality product.

=== Restoration Ecology
<restoration-ecology>
- Bioswales

- #cite(<fischerMakingDecadeEcosystem2021>, form: "prose") UN announced 2021–2030 the Decade on Ecosystem Restoration

=== #strong[Environmental DNA]
<environmental-dna>
- #cite(<ogramExtractionPurificationMicrobial1987>, form: "prose") isolating cellular DNA from various sediment types.

- #cite(<peterandreysmitharchivepageHowEnvironmentalDNA2024>, form: "prose") describes

=== Digital Twins
<digital-twins>
- We can use all the data being recorded to provide a Digital Twin of the planet, nature, ecosystems and human actions to help us change our behavior and optimize for planetary wellbeing.

- The EU is developing a digital twin of Earth to help sustainability prediction and planning, integrating Earth’s various systems such as climate, hydrology, ecology, etc, into a single model @hoffmannDestinationEarthDigital2023[ and #cite(<DestinationEarthShaping2023>, form: "prose");];.

- EU releases strategic foresight reports since 2020 #cite(<europeancommissionStrategicForesight2023>, form: "prose")

== Mitigation & Adaption
<mitigation-adaption>
Many companies are developing technologies for mitigation.

==== Cap & Trade
<cap-trade>
The share of CO#sub[2] emissions among people around the world is highly unequal across the world (referred to as #strong[#emph[Carbon Inequality];];). @chancelGlobalCarbonInequality2022 reports "one-tenth of the global population is responsible for nearly half of all emissions, half of the population emits less than 12%".

- One example is the ICT sector.

- #cite(<bajarinPCSalesAre>, form: "prose") Over 300 million PCs sold in 2022

  - #cite(<GreenDiceReinventingIdea2021>, form: "prose") Estonian company "sustainable lifecycle management of IT equipment"
  - #cite(<arilehtKestlikkuseSuunanaitajadSaadavad2022>, form: "prose") Recycle your phone, FoxWay and Circular economy for PCs.
  - #cite(<zhouCarboneconomicInequalityGlobal2022>, form: "prose") ICT is an example of inequality, while emerging economies bear 82% of the emissions, developed countries gain 58% of value.

=== Emissions’ Data
<emissions-data>
Data about green house gas emissions.

#figure(
  align(center)[#table(
    columns: (40%, 31.67%, 27.5%),
    align: (auto,auto,auto,),
    [Regional Avergage Per Capita Emissions (2020)], [Highest Per Capita Emissions (2021)], [Highest Total Emissions (2021)],
    [North America 13.4 CO#sub[2];e tonnes], [Palau], [China],
    [Europe 7.5 CO#sub[2];e tonnes], [Qatar], [United States],
    [Global Average 4.1 CO#sub[2];e tonnes], [Kuwait], [European Union],
    [Africa and the Middle East 1.7 CO#sub[2];e tonnes], [Bahrain], [India],
    [], [Trinidad and Tobago], [Russia],
    [], [New Caledonia], [Japan],
    [], [United Arab Emirates], [Iran],
    [], [Gibraltar], [Germany],
    [], [Falkland Islands], [South Korea],
    [], [Oman], [Indonesia],
    [], [Saudi Arabia], [Saudi Arabia],
    [], [Brunei Darussalam], [Canada],
    [], [Canada], [Brazil],
    [], [Australia], [Turkey],
    [], [United States], [South Africa],
  )]
  , caption: [Comparing highest per capita CO#sub[2] emissions (mostly from oil producers) vs regional average per capita CO#sub[2] emissions vs total CO#sub[2] emissions@ivanovaQuantifyingPotentialClimate2020@worldresourcesinstituteCO2EmissionsMetric2020@europeancommission.jointresearchcentre.CO2EmissionsAll2022@crippaFossilCO2GHG2020@liuMonitoringGlobalCarbon2023.]
  , kind: table
  )

"The world’s top 1% of emitters produce over 1000 times more CO2 than the bottom 1%" #cite(<ieaWorldTopEmitters2023>, form: "prose")

#cite(<crippaFossilCO2GHG2020>, form: "prose") reports latest figures from the EU’s Emissions Database for Global Atmospheric Research (EDGAR)

The EU Copernicus satellite system reveals new greenhouse emissions previously undetected @danielvarjoNyaSatelliterAvslojar2022.

=== Emissions Trading Schemes
<emissions-trading-schemes>
From Carbon Offsets to Carbon Credits

Retiring CO#sub[2] allowances

- Facilitating citizens’ access to CO#sub[2] emissions trading may be an efficient method to organize large-scale CO#sub[2] retiring #cite(<rousseEnvironmentalEconomicBenefits2008>, form: "prose")
- "A carbon credit represents one tonne of carbon dioxide that has been prevented from entering or has been removed from the atmosphere" @annawatsonCarbonCreditRetirements2023@annawatsonDeepDiveCarbon2022.

As of 2023 there isn’t a single global CO#sub[2] trading market but rather several local markets as described in the table below #cite(<InternationalCarbonMarket>, form: "prose");.

#figure(
  align(center)[#table(
    columns: (11.49%, 5.96%, 82.13%),
    align: (auto,auto,auto,),
    [CO#sub[2] Market], [Launch Date], [Comments],
    [European Union], [2005], [EU: #cite(<araujoEuropeanUnionMembership2020>, form: "prose");],
    [], [], [],
    [South Korea], [2015], [],
    [China], [2021], [China’s national emissions trading scheme (ETS) started in 2021 priced at 48 yuan per tonne of CO#sub[2];, averaged at 58 yuan in 2022 @liuIndepthWillChina2021@ivyyinCommodities2023China2023.],
    [United States of America], [2013], [No country-wide market; local CO#sub[2] markets in California, Connecticut, Delaware, Maine, Maryland, Massachusetts, New Hampshire, New York, Rhode Island, and Vermont],
    [New Zealand], [2008], [New Zealand #cite(<rontardPoliticalConstructionCarbon2022>, form: "prose") (need access, important ncku doesn’t subscribe)],
    [Canada], [2013], [],
  )]
  , caption: [CO#sub[2] credit trading markets around the world from #cite(<InternationalCarbonMarket>, form: "prose");.]
  , kind: table
  )

Most of the world is not part of a CO#sub[2] market.

- @sipthorpeBlockchainSolutionsCarbon2022 compares traditional and blockchain-based solutions to carbon trading.
- @unitednationsenvironmentprogrammeunepEmissionsGapReport2021 report. “The Emissions Gap Report (EGR) 2021: The Heat Is On shows that new national climate pledges combined with other mitigation measures put the world on track for a global temperature rise of 2.7°C by the end of the century. That is well above the goals of the Paris climate agreement and would lead to catastrophic changes in the Earth’s climate. To keep global warming below 1.5°C this century, the aspirational goal of the Paris Agreement, the world needs to halve annual greenhouse gas emissions in the next eight years.
- @unitednationsenvironmentprogrammeunepEmissionsGapReport2021 report "If implemented effectively, net-zero emissions pledges could limit warming to 2.2°C, closer to the well-below 2°C goal of the Paris Agreement. However, many national climate plans delay action until after 2030. The reduction of methane emissions from the fossil fuel, waste and agriculture sectors could help close the emissions gap and reduce warming in the short term, the report finds. Carbon markets could also help slash emissions. But that would only happen if rules are clearly defined and target actual reductions in emissions, while being supported by arrangements to track progress and provide transparency."
- @unitednationsenvironmentprogrammeEmissionsGapReport2022 2022 Emissions Gap report.

=== Carbon Markets
<carbon-markets>
For the individual person, there’s no direct access to CO#sub[2] markets, however there are different types of brokers who buy large amounts of carbon credits and resell them in smaller quantities to retail investors. "Carbon pricing is not there to punish people," says Lion Hirth #cite(<lionhirthLionHirthTwitter>, form: "prose");. "It’s there to remind us, when we take travel, heating, consumption decisions that the true cost of fossil fuels comprises not only mining and processing, but also the damage done by the CO#sub[2] they release."

==== The Price of CO#sub[2] Differs Across Markets
<the-price-of-co2-differs-across-markets>
#cite(<sternCarbonNeutralEconomy2022>, form: "prose") reports carbon-neutral economy needs higher CO#sub[2] prices. #cite(<rennertComprehensiveEvidenceImplies2022>, form: "prose");: Carbon price should be 3,6x higher that it is currently. #cite(<ritzGlobalCarbonPrice2022>, form: "prose") argues optimal CO#sub[2] prices could be highly asymmetric, low in some countries and high (above the social cost of CO#sub[2];) in countries where production is very polluting.

- #cite(<igeniusLetTalkSustainable2020>, form: "prose")
- The total size of carbon markets reached 949 billion USD in 2023, including Chinese, European, and North American CO2e trading @lsegGlobalCarbonMarkets2024.

==== Compliance Markets
<compliance-markets>
#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Compliance Markets], [Price (Tonne of CO#sub[2];)],
    [EU], [83 EUR],
    [UK], [40 Pounds],
    [US (California)], [29 USD],
    [Australia], [32 USD],
    [New Zealand], [50 USD],
    [South Korea], [5.84 USD],
    [China], [8.29 USD],
    [], [],
  )]
  , caption: [Compliance market CO#sub[2] prices on August 12, 2023; data from @emberCarbonPriceTracker2023@tradingeconomicsEUCarbonPermits2023@carboncreditsLiveCarbonPrices2023.]
  , kind: table
  )

==== Voluntary Carbon Markets
<voluntary-carbon-markets>
Voluntary Carbon Markets are …

Voluntary Carbon Markets (VCM) lack standardization and transparency @elakhodaiWhyVCMNeeds2023.

#strong[#emph[Carbon Credits];] are useful for private companies who wish to claim #emph[carbon neutrality, climate positivity];, or other related claim, which might be viewed in good light by their clients or allow the companies to adhere to certain legislative requirements.

There are many companies which facilitate buy carbon credits as well as a few organizations focused on carbon credit verification.

- In Estonia, startups Arbonic and Single.Earth are trialing this approach in several forests.
- Carbon Credit Retirement?
- Methodologies: #cite(<MethodologyGHGCoBenefits2022>, form: "prose")
- #cite(<klimadaoOpenCallAlternative2023>, form: "prose") call for an open standard

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Voluntary Markets], [Price (Tonne of CO#sub[2];)],
    [Aviation Industry Offset], [\$0.93],
    [Nature Based Offset], [\$1.80],
    [Tech Based Offset], [\$0.77],
  )]
  , caption: [Voluntary market CO#sub[2] prices on August 12, 2023; data from @carboncreditsLiveCarbonPrices2023.]
  , kind: table
  )

==== Fossil Fuels
<fossil-fuels>
Fossil fuels are what powers humanity as well as the largest source of CO#sub[2] emissions. #cite(<ieaGlobalEnergyReview2022>, form: "prose") reports "Global CO#sub[2] emissions from energy combustion and industrial processes rebounded in 2021 to reach their highest ever annual level. A 6% increase from 2020 pushed emissions to 36.3 gigatonnes". As on June 2023, fossil fuel based energy makes up 82% of energy and is still growing #cite(<instituteEnergySystemStruggles2023>, form: "prose");. The 425 largest fossil fuel projects represent a total of over 1 gigatons in CO#sub[2] emissions, 40% of which were new projects #cite(<kuhneCarbonBombsMapping2022>, form: "prose");. #cite(<tilstedEndingFossilbasedGrowth2023>, form: "prose") expects the fossil fuel industry to continue grow even faster. In July 2023, the U.K. granted hundreds of new oil and gas of project licenses in the North Sea @RishiSunakGreenlight2023.

==== Renewable Energy
<renewable-energy>
- 10 countries use almost 100% renewable energy

There’s ample evidence from several countries suggesting moving to renewal energy brings environmental benefits:

- #cite(<AMIN2022113224>, form: "prose") suggests "removing fossil fuel subsidies and intra-sectoral electricity price distortions coupled with carbon taxes provides the highest benefits" for both the economy and the environment in Bangladesh.

- #cite(<luoControllingCommercialCooling2022>, form: "prose") suggests using reinforcement learning to reduce energy use in cooling systems.

- The true cost of products is hidden. The work is hidden.

- Montreal protocol eradicates CfCs and the ozone holes became whole again.

==== Emission Scopes Organize Calculating CO2e
<emission-scopes-organize-calculating-co2e>
The U.S. National Public Utilities Council (NPUC) decarbonization report provides a useful categorization of #strong[#emph[emission scopes];] applicable to companies and for organizing emission reduction schemes @nationalpublicutilitiescouncilAnnualUtilityDecarbonization2022. For example, for consumers in Australian states and territories in 2018, 83% of the GHG emissions are Scope 3, meaning indirect emissions in the value chain #cite(<goodwinTargetingDegreesGlobal2023>, form: "prose");.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Emission Scope], [Emission Source],
    [Scope 1], [Direct emissions],
    [Scope 2], [Indirect electricity emissions],
    [Scope 3], [Value chain emissions],
  )]
  , caption: [From #cite(<nationalpublicutilitiescouncilAnnualUtilityDecarbonization2022>, form: "prose");.]
  , kind: table
  )

One’s scope 3 emissions are someone else’s scope 1 emissions.

- Mapping pollution sources in China #cite(<xieEcologicalCivilizationChina2021>, form: "prose")

==== Carbon Capture
<carbon-capture>
Many technology startups focused on climate solutions (often referred to as climatech by the media), have proposed a range of approaches to CO#sub[2] reduction in the atmosphere.

- #cite(<vitilloRoleCarbonCapture2022>, form: "prose") illustrates how direct air capture of CO#sub[2] is difficult because of low concentration and CO#sub[2] capture at the source of the emissions is more feasible.

- #cite(<gaureTrueNotTrue2022>, form: "prose") simulate a CO#sub[2] free electricity generation system in the European Union where "98% of total electricity production is generated by wind power and solar; the remainder is covered by a backup technology.". The authors stipulate it’s possible to power the EU without producing CO#sub[2] emissions.

- #strong[Important: "creating sustainability trust in companies in realtime"]

- #cite(<howardPotentialIntegrateBlue2017>, form: "prose") argues Oceans play crucial role in carbon capture.

==== Social Cost of Carbon Measures Compound CO#sub[2] Impact
<social-cost-of-carbon-measures-compound-co2-impact>
Sustainability is filled with complexities, where CO#sub[2] emission is compounded by biodiversity loss, child labor, slavery, poverty, prostitution, dangerous chemicals, and many other issues become intertwined @tedxSustainableBusinessFrank2020. One attempt to measure these complexities, is the Social Cost of Carbon (SCC) which is defined as "additional damage caused by an extra unit of emissions" @kornekSocialCostCarbon2021@zhenSimpleEstimateSocial2018. For example the cost of damages caused by "one extra ton of carbon dioxide emissions" @stanforduniversityProfessorsExplainSocial2021. SCC variations exists between countries @tolSocialCostCarbon2019 and regions @wangMeasurementChinaProvincial2022.

- As shown in the Phillipines by @chengAssessingEconomicLoss2022, with increasing extreme weather events, "businesses are more likely to emerge in areas where infrastructure is resilient to climate hazards". @jerrettSmokeCaliforniaGreenhouse2022 says, In California, "Wildfires are the second most important source of emissions in 2020" and "Wildfires in 2020 negate reductions in greenhouse gas emissions from other sectors."

- @linOpportunitiesTackleShortlived2022 says, apart from CO#sub[2];, reduction of other atmospheric pollutants, such as non-CO#sub[2] greenhouse gases (GHGs) and short-lived climate pollutants (SLCPs) is required for climate stability.

- @wangMultimodelAssessmentClimate2022: Quantifying climate damage proposes scenarios of climate damage.

==== Country-Level Nationally Determined Contributions (NDCs)
<country-level-nationally-determined-contributions-ndcs>
- #cite(<unfcccNDC2022>, form: "prose") The State of Nationally Determined Contributions

While most countries have not reached their Nationally Determined Contributions, the Climate Action Tracker data portal allows to compare countries @climateanalyticsClimateActionTracker2023.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    [Country or Region], [NDC target],
    [China], [Highly insufficient],
    [Indonesia], [Highly insufficient],
    [Russia], [Critically insufficient],
    [EU], [Insufficient],
    [USA], [Insufficient],
    [United Arab Emirates], [Highly insufficient],
    [Japan], [Insufficient],
    [South Korea], [Highly insufficient],
    [Iran], [Critically insufficient],
    [Saudi Arabia], [Highly insufficient],
  )]
  , caption: [Climate Action Tracker’s country comparison of the 10 top polluters’ climate action.]
  , kind: table
  )

- #cite(<fransenStateNationallyDetermined2022>, form: "prose") notes that the majority of Nationally Determined Contributions (NDCs) are dependent on financial assistance from the international community.

TODO

- "triple turn"
- lack of transparency
- Call for GOP contributors’ transparency

==== SDGs
<sdgs>
- SDGs need to discussed in their totality #cite(<popkovaTheoryDigitalTechnology2022>, form: "prose");.

- German Institute of Development and Sustainability (IDOS) connects SDGs to NDCs. #cite(<dzeboParisAgreementSustainable2023>, form: "prose")

- International Energy Agency (IEAs), Decarbonisation Enablers #cite(<ieaTrackingCleanEnergy2023>, form: "prose")

== Eco-Design
<eco-design>
#strong[#emph[Designing for Sustainability aka Circular Design or Eco-Design];] encompasses all human activities, making this pursuit an over-arching challenge across all industries also known as circular economy. Assuming that as individuals we want to act in a sustainable way, how exactly would be go about doing that?

- "Evolution of design for sustainability: From product design to design for system innovations and transitions"

- #cite(<DELAPUENTEDIAZDEOTAZU2022718>, form: "prose") #strong[Life Cycle Assessment and environmental impact analysis are needed to provide eco-design scenarios.]

- #cite(<europeanparliamentEcodesignSustainableProducts2022>, form: "prose") proposal "On 30 March 2022, the European Commission put forward a proposal for a regulation establishing a general framework for setting eco-design requirements for sustainable products, repealing rules currently in force which concentrate on energy-related products only." Virginijus Sinkevičius, EU Commissioner for the Environment, Oceans and Fisheries, is quoted as describing eco-design "respects the boundaries of our planet" #cite(<europeancommissionGreenDealNew2022>, form: "prose")

- Forming an emotional bond with the product makes it feel more valuable @zonneveldEmotionalConnectionsObjects2014. This has implications for sustainability as the object is less likely to be thrown away.

=== Regenerative design
<regenerative-design>
- Dematerialize economies is not enough.

=== Biomimicry
<biomimicry>
- following nature

=== Biodesign
<biodesign>
MIT is a source of many fantastic innovations.

- Neri Oxman, biomaterials MIT media lab, 15. sept. 2020

- Neri Oxman’s expressions: "ecology-indifferent", "naturing", "mother naturing", "design is a practice of letting go of all that is unnecessary", "nature should be our single client".

- Use imagination

- Societal movements change things: implication for design: build a community

- Processes sustain things: implication for design: built an app

=== AI-Assisted Design Enables Desiging for Sustainability
<ai-assisted-design-enables-desiging-for-sustainability>
#cite(<guptaAnalysisArtificialIntelligencebased2023>, form: "prose") argues software is key to building more sustainable products, already for decades. More recently, companies like AutoDesk are putting CO#sub[2] calculations inside their design software.

- AI has the potential to provide the parameters for sustainability. #cite(<singhArtificialNeuralNetwork2023>, form: "prose") proposes an AI tool for deciding the suitable life cycle design parameters.
- #cite(<SustainabilityStartsDesign>, form: "prose");: "Sustainability starts in the design process, and AI can help".

=== Circular Economy
<circular-economy>
Circular economy is a tiny part of the world economy. #cite(<circleeconomyCircularityGapReport2022>, form: "prose") reports only 8.6% of world economy is circular and #emph[100B tonnes of virgin materials] are sourced every year.

- #cite(<mcdonoughCradleCradleRemaking2002>, form: "prose") book

- #cite(<mcgintyHowBuildCircular2020>, form: "prose");: How to Build a Circular Economy

- #cite(<dullCircularSupplyChain2021>, form: "prose") book

- #cite(<chapmanDesignEmotionalDurability2009>, form: "prose") argues in his seminal paper (and later in his book) for #strong[#emph["Emotionally Durable Design"];];, the simple idea that we hold to things we value and thus they are sustainable. We don’t throw away a necklace gifted to us by mom, indeed this object might be passed down for centuries. #cite(<roseEnchantedObjectsInnovation2015>, form: "prose") has a similar idea, where #strong[#emph["Enchanted Objects"];] become so interlinked with us, we’re unlikely to throw them away.

- Growing public understanding of how nature works and intersects with our use of money.

- #cite(<hedbergCircularEconomyRole2021>, form: "prose") argues digitization and data sharing is a requirement for building a circular economy.

- "Circular Petrochemicals" #cite(<langeCircularCarbochemicalsMetamorphosis2021>, form: "prose")

- Supply chain transparency enables stakeholder accountability @circulariseFlexibleTransparencyPart2018@dooreyTransparentSupplyChain2011@foxUncertainRelationshipTransparency2007.

- Recycling Critical Raw Materials, digitalisation of mining allows enhance the reliability of supply chains @crmallianceEITRawMaterials2020.

- EIT RawMaterials

== Policy Context
<policy-context>
- "In the context of the EU Plastics Strategy, the European Commission has launched a pledge to increase the use of recycled content to 10 million tons by 2025. To address this, Circularise Plastics Group launched an “Open Standard for Sustainability and Transparency" based on blockchain technology & Zero-knowledge Proofs” #cite(<circulariseEuPCCircularisePlastics2020>, form: "prose")

- "data-exchange protocol with privacy at its heart" #cite(<circulariseCirculariseRaisesMillion2020>, form: "prose")

- EU AI Law #cite(<lomasDealEUAI2024>, form: "prose")

=== The Policy Context in Europe From 2023 to 2030
<the-policy-context-in-europe-from-2023-to-2030>
We have an opportunity to re-imagine how every product can be an eco-product and how they circulate in our circular economy.

Timeline of the Policy Context:

- In 2019 by the von der Leyen commission adopted the European Union (EU) #strong[Green Deal] strategy.

- In 2021 the Commision proposed a goal of reducing CO2e emissions by 55% by 2030 under the #emph[Fit for 55] policy package consisting of a wide range of economic measures.

- In November 2022, the proposal was adopted by the EU Council and EU Parliament with an updated goal of 57% of CO2e reductions compared to 1990. This proposal is set to become a binding law for all EU member countries (#cite(<europeancommissionEuropeanGreenDeal2019>, form: "prose");; #cite(<europeancommissionSustainableEurope20302019>, form: "prose");; #cite(<EUReachesAgreement2022>, form: "prose");; #cite(<europeancouncilFit55EU2022>, form: "prose");).

- In March 2022, the EU Circular Economy Action Plan was adopted, looking to make sustainable products #emph[the norm] in EU and #emph[empowering consumers] as described in #cite(<europeancommissionCircularEconomyAction2022>, form: "prose");. Each product covered by the policy is required to have a #strong[#emph[Digital Product Passport];] which enables improved processing within the supply chain and includes detailed information to empower consumers to understand the environmental footprint of their purchases. It’s safe to say the large majority of products available today do not meet these criteria.

==== Wellbeing Economy Governments is an Example of Country-level Collaboration
<wellbeing-economy-governments-is-an-example-of-country-level-collaboration>
- Finland, Iceland, New Zealand, Scotland, Wales, Canada https:\/\/weall.org/wego

=== European Green Deal
<european-green-deal>
- #cite(<EuropeanGreenDeal2021>, form: "prose")
- #cite(<switch2greenEUGreenDeal2023>, form: "prose")

It’s up to legislators to provide sustainable products on our marketplace… but until we do, use the green filter.

- One of the EU goals is reducing consumption
- Tacking our consumption habits
- Europe is the hotbed of sustainability
- #cite(<imanghoshMappedWhereAre2020>, form: "prose")
- #cite(<lamoureuxNotableSustainableCompanies2018>, form: "prose") Florida sustainable companies
- #cite(<michaelhoulihanItOfficialCustomers2018>, form: "prose") customers prefer sustainable companies
- #cite(<rajagopalanInflationReductionAct2023>, form: "prose");: In the US, the #emph[Inflation Reduction Act] provides funding to development of decarbonizing technologies and includes plans to combat air pollution, reduce green house gases and address environmental injustices.

=== Eco-Design is a Key EU Sustainable Policy Design Tool
<eco-design-is-a-key-eu-sustainable-policy-design-tool>
A large part of the proposal by #cite(<commissionEcodesignYourFuture2014>, form: "prose") is #strong[#emph[eco-design];];, as a large part of product lifecycle environmental impact is defined in the design process.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    [Quality], [], [],
    [Durable], [Reparable], [Easy to recycle],
    [Reusable], [Easy to maintain], [Energy efficient],
    [Upgradable], [Easy to refurbish], [Resource efficient],
  )]
  , caption: [Eco-design framework proposes 9 values to strive for in high quality products.]
  , kind: table
  )

=== Sustainbility Policy is Shifting Around the World
<sustainbility-policy-is-shifting-around-the-world>
Politics matters in sustainability.

In the European Union (EU), a wide range of legislative proposals, targets, organizations, and goals already exists across diverse countries. Upcoming laws aim to harmonize approaches to sustainability and raise standards for all members states, in turn influencing producers who wish to sell in the EU common market.

- In Brazil, deforestation fell 60% in 1 year, based on remote satellite reconnaissance, after the election of a more pro-environment leadership #cite(<wattsAmazonDeforestationFalls2023>, form: "prose");.

- #cite(<EUTaxonomySustainable>, form: "prose") report: The EU has a #strong[#emph[taxonomy of environmentally sustainable economic activities];] published by the Technical Expert Group (TEG) on sustainable finance.

- The proposal for a Nature Restoration Law by the European Commission requiring member countries to restore 20% of EU’s degraded ecosystems by 2030 and full restoration by 2050 has not yet passed #cite(<ScientistsUrgeEuropean2023>, form: "prose") and is facing a backlash #cite(<davidpintoBacklashNatureRestoration2023>, form: "prose");.

- #cite(<MANZARDO2021149507>, form: "prose") #strong[(need access!)]

- #cite(<INARRA2022100727>, form: "prose") #strong[(need access!)]

- #cite(<MUNARO2022566>, form: "prose") #strong[(need access!)]

- #cite(<BASSANI2022151565>, form: "prose") #strong[(need access!)]

- #cite(<VANDOORSSELAER2022189>, form: "prose") #strong[(need access!)]

- #cite(<NUEZ2022133252>, form: "prose") shows how electric vehicles may increase CO#sub[2] emissions in some areas, such as Canary Islands, where electricity production is polluting.

- #cite(<ROSSI2022823>, form: "prose") shows how introducing sustainability early in the design process and providing scenarios where sustainability is a metric, it’s possible to achieve more eco-friendly designs.

- #cite(<TIERNAN2022169>, form: "prose") microplastics are a real concern

- #cite(<ARRANZ2022131738>, form: "prose") developing circular economy is really complex

- #cite(<CHEBA2022108601>, form: "prose")

- #cite(<RUIZPASTOR2022130495>, form: "prose")

- #cite(<MIYOSHI2022267>, form: "prose") takes the example of ink toner bottles and shows in a case study how standardized compatibility between older and newer systems can save resources and results in sustainability savings.

- Finding green products and supporting companies making them

- Supporting legislative changes

- Track you consumption, saving, investing. Shift balance towards saving and investing.

- #cite(<nastaraanvadoodiEcodesignRequirementsDrive2022>, form: "prose")

- #cite(<europeancommissionEcodesignSustainableProducts2022>, form: "prose") Ecodesign for sustainable products

=== Waste Generation is Still Increasing
<waste-generation-is-still-increasing>
#cite(<liuGlobalPerspectiveEwaste2023>, form: "prose") reports, e–waste is growing 3%–5% every year, globally. @thukralExploratoryStudyProducer2023 identifies several barriers to e-waste management among producers including lack of awareness and infrastructure, attitudinal barriers, existing #emph[informal] e-waste sector, and the need for an e-waste license.

=== Extended Producer Responsibility Enables Compannies to be Resposible
<extended-producer-responsibility-enables-compannies-to-be-resposible>
Extended Producer Responsibility (EPR) is a policy tool first proposed by Thomas Lindhqvist in Sweden in 1990 \[ADD CITATION\], aimed to encourage producers take responsibility for the entire life-cycle of their products, thus leading to more eco-friendly products. Nonetheless, EPR schemes do not guarantee circularity and may instead be designed around fees to finance waste management in linear economy models @christiansenExtendedProducerResponsibility2021. The French EPR scheme was upgraded in 2020 to become more circular @jacquesvernierExtendedProducerResponsibility2021.

In any case, strong consumer legislation (such as EPR) has a direct influence on producers’ actions. For example, in #cite(<hktdcresearchFranceExpandsProducer2022>, form: "prose");, the Hong Kong Trade Development Council notified textile producers in July 2022 reminding factories to produce to French standards in order to be able enter the EU market. #cite(<pengExtendedProducerResponsibility2023>, form: "prose") finds that the #strong[#emph[Carbon Disclosure Project];] has been a crucial tool to empower ERP in Chinese auto-producers.

- The success of EPR can vary per type of product. For car tires, the EPR scheme in the Netherlands claims a 100% recovery rate #cite(<campbell-johnstonHowCircularYour2020>, form: "prose");.

One type of legislation that works?

- #cite(<steenmansFosteringCircularEconomy2023>, form: "prose") Argues for the need to engage companies through legislation and shift from waste-centered laws to product design regulations.

- In Europe, there’s large variance between member states when in comes to textile recycling: while Estonia and France are the only EU countries where separate collection of textiles is required by law, in Estonia 100% of the textiles were burned in an incinerator in 2018 while in France textiles are covered by an Extended Producer Responsibility (EPR) scheme leading to higher recovery rates (Ibid).

- Greyparrot AI to increase recycling rates #cite(<natashalomasUKAIStartup2024>, form: "prose")

=== Return, Repair, Reuse
<return-repair-reuse>
- There’s a growing number of companies providing re-use of existing items.
- #cite(<SmartSwap>, form: "prose") For example, Swap furniture in Estonia

Bring back your bottle and cup after use.

- #cite(<pastorProposingIntegratedIndicator2023>, form: "prose") proposes a #strong[product repairability index (PRI)]
- #cite(<formentiniDesignCircularDisassembly2023>, form: "prose")
- Recycling @lenovoFastTechUnsustainable2022 "rethinking product design and inspiring consumers to expect more from their devices"
- "design is a tool to make complexity comprehensible" like the Helsinki chapel. there’s either or a priest or a social worker. it’s the perfect public service. "limit the barrier of entry for people to discover". elegant.
- #cite(<zeynepfalayvonflittnerFalayTransitionDesign>, form: "prose")

=== Packaging
<packaging>
Packaging is a rapidly growing industry which generates large amounts of waste #cite(<adaChallengesCircularFood2023>, form: "prose");. #cite(<bradleyLiteratureReviewAnalytical2023>, form: "prose");: "Over 161 million tonnes of plastic packaging is produced annually."

- #cite(<ChallengesOpportunitiesSustainable2022>, form: "prose")
- #cite(<ProteinBrandsConsumers2022>, form: "prose")
- #cite(<DetailrichSustainablePackaging2010>, form: "prose")
- @lernerHowCocaColaUndermines2019 Coca Cola plastic pollution. ESG ratings have faced criticism for lack of standards and failing to account for the comprehensive impact a company is having. @foleyRestoringTrustESG2024 notes how Coca Cola fails to account the supply chain water usage when reporting becoming "water neutral" and calls on companies to release more detailed information.
- #cite(<SulapacReplacingPlastic>, form: "prose")

=== Factories Can Become More Transparent
<factories-can-become-more-transparent>
- Regional supply chains for decarbonising steel: "co-locating manufacturing processes with renewable energy resources offers the highest energy efficiency and cost reduction" Japanese-Australia study s #cite(<devlinRegionalSupplyChains2022>, form: "prose")

- Transparency about the polluting factories where the products come from.. the product journey

- virtual factories

- Tracing emissions from factory pipes… what’s the app?

- Factories should be local and make products that can be repaired.

- Carbon-neutral factories "made in carbon-neutral factory" list of products

- #cite(<stefanklebertCarbonneutralManufacturingPossible2022>, form: "prose")

- #cite(<vdizentrumressourceneffizienzCarbonneutralGreenFactory2020>, form: "prose")

- #cite(<CO2neutralFactories>, form: "prose") and #cite(<InnocentOpens200m>, form: "prose") CO#sub[2] neutral factories?

- @MakeYourWebsite@Ecograder CO#sub[2] neutral websites

- #cite(<ericfoggWhatLightsOut2020>, form: "prose") Lights-Out Manufacturing

- #cite(<mowbrayWorldFirstFree2018>, form: "prose") "World’s first free digital map of apparel factories"

- #cite(<FFCFairFactories>, form: "prose") Factory compliance - Fair Factories

- Planet Factory

- #cite(<CompaniesWeHave>, form: "prose") Plastic waste makers index, sources of plastic waste

== Design Implications
<design-implications-1>
#figure(
  align(center)[#table(
    columns: (6.25%, 93.75%),
    align: (auto,auto,),
    [Category], [Implication],
    [Transparency

    Speed

    ], [In unison, the reviewed technologies and practices move us closer to enabling #emph[realtime ESG];: up-do-date transparent information about how our product are produced. Realtime ESG is a building block to enable consumers and investors make more accurate, real-world purchase decisions.],
    [Pollution

    Actionability

    ], [#emph[People live in the polluted areas are so used to it. What app to wake them up? "You live in a highly polluted area. Here’s the TOP 10 companies causing pollution. Here’s what you can do."];],
    [Health Tracking], [Blood testing and biomarkers allow people to track their health. I’m introducing the concept of 'eco-markers' to follow the sustainability of human activities.],
    [Circular Economy], [AI can help us make sense of the vast amounts of sustainability data generated daily.],
    [EPR], [ERP and CDP data should be part of Green Filter.],
    [], [],
    [], [],
    [], [],
    [], [],
    [], [],
  )]
  , caption: [Implications]
  , kind: table
  )

#horizontalrule

title: Design sidebar\_position: 2 editor: render-on-save: false jupyter: python3 suppress-bibliography: true

#horizontalrule

== Platform Economy Popularises Data-Driven Design
<platform-economy-popularises-data-driven-design>
As we humans go about our daily business, we produce massive amounts of data, which is useful for designing better products. There are many approaches to design and the majority share the common goal of designing for a good user experience.

Designing for high retention (users keep coming back).

=== Capturing User Data
<capturing-user-data>
Platform economy companies capture large amounts of data from users.

#emph[Network Effects,] the more people use a platform, the more valuable it becomes.

#strong[Data is The Interface:] #emph[platform economy] marketplace companies like Airbnb and Uber match idle resources with retail demand and optimize how our cities work.

By continuously adding features (and provided consumer legislation allows it), platforms can evolve into superapps. Superapps are possible thanks to #strong[Nudge, Economies of Scale, Network Effects, Behaviour Design.]

Personalization at scale: the largest businesses today (measured in number of users) design the whole user experience. Popular consumer platforms strive to design solutions that feel personalized at every touchpoint on the user journey (to use the language of service design) at the scale of hundreds of billions of users.

Superapps are honeypots of data that is used for many types of behavior modeling. @suarezEnhancingUserIncome2021 suggests using alternative data from super-apps to estimate user income levels, including 4 types of data: Personal Information, Consumption Patterns, Payment Information, and Financial services. @roaSuperappBehavioralPatterns2021 finds super-app alternative data is especially useful for credit-scoring young, low-wealth individuals. The massive amounts of data generated by these companies are used by smart cities to re-design their physical environments.

#figure(
  align(center)[#table(
    columns: (27.78%, 36.11%, 36.11%),
    align: (auto,auto,auto,),
    table.header([Enablers of Platform Economics], [Good], [Bad],),
    table.hline(),
    [Network effects], [The more people use a platform, the more valuable it becomes.], [Data is not portable. You can’t leave because you’ll lose the audience.],
    [Scalability], [], [],
    [Data-driven], [], [],
    [Behaviour Design], [], [],
  )]
  , kind: table
  )

- Superapps are prevalent in China and South-East Asia. @giudice2020wechat finds WeChat has had a profound impact on changing China into a cashless society, underlining how one mobile app can transform social and financial interactions of an entire country. @vecchiTwoTalesInternationalization2022 China is the home of many superapps and this paper discusses the strategies taken to expand to other markets. @shabrinanurqamaraniEFFECTSMOBILESERVICE2020 discusses the system consistency and quality of South–East Asian superapps Gojek and Grab.

- Platform economy companies have been criticized for their lack of workers rights (ESG). @RidersSmogPollution2024 uses portable air pollution tracking devices to documents how gig workers are subjected to pollution.

- Uber is creating an all-purpose platform; only 4.1% of rides were electric @levyUberCEOSays2023.

- Twitter (X) is becoming a superapp?

Could there be Sustainability Superapps?

- How to design sustainability superapps? Lots of options in a single app. @fleetmanagementweeklySustainableSuperappShows2022 "Sustainability and superapps top Gartner’s Top 10 2023 Trends List". @davewallaceRiseCarboncentricSuper2021 "The rise of carbon-centric super apps". @goodbagGoodbagSustainableSuper2023 "goodbag: Sustainable Super App". What would a sustainable investment platform that matches green investments with the consumers look like, if one saw the side-by-side comparison of investment vehicles on their ESG performance? Also @bernardSustainabilitySuperappsTop2022.

- #cite(<undheimEcoTechInvesting2024>, form: "prose") Ecotech

- #cite(<loriperriWhatSuperapp2022>, form: "prose")

- #cite(<PartnershipBringsSustainability2022>, form: "prose")

- #cite(<CompanyNowDominating2021>, form: "prose") PayPal dominance

- #cite(<zengThreeParadoxesBuilding2015>, form: "prose") #strong[(need to pay for article!)]

- #cite(<huangRedomesticatingSocialMedia2021>, form: "prose") #strong[(need to pay for article!)]

- #cite(<WillEuropeGet2022>, form: "prose")

- @cuppiniWhenCitiesMeet2022 historical overview of the development of capitalism from linear #strong[#emph[Fordism];] through platform economy and logistics’ revolution which allows for circular economies to happen in a city.

- Adaptive AI

== Data Enables Generative UIs
<data-enables-generative-uis>
In design there are many overlapping terms created by different people for diverse purposes from distinguishing a particular type of design to marketing oneself as the creator of the term.

There are many ways to structure design theory but for the purposes of this AI-focused research, I will begin from Generative UI.

structure: data-driven design, generative UI

AI will decide what kind of UI to show to you based on the data and context

- Replit, a startup known for allowing user build apps in the web browser, released Openv0, a framework of AI-generated UI components @replitReplitOpenv0OpenSource2023. "Components are the foundation upon which user interfaces (UI) are built, and generative AI is unlocking component creation for front-end developers, transforming a once arduous process, and aiding them in swiftly transitioning from idea to working components."
- Vercel introduced an open-source prototype UI-generator called V0 which used large language models (LLMs) to create code for web pages based on text prompts @vercelIntroducingV0Generative2023. Other similar tools quickly following including Galileo AI, Uizard AutoDesigner and Visily @WhoBenefitsMost2024.
- In 2014, the eminent journal #emph[Information Sciences] decided to dedicate a special section to AI-generated software to call attention to this tectonic shift in software development @reformatSpecialSectionApplications2014.
- As machines become more capable, machines will eventually be capable of producing machines.
- Generative UIs are largely invented in practice, based on user data analysis and experimentation, rather than being built in theory. Kelly Dern, a Senior Product Designer at Google lead a workshop in early 2024 on #emph[GenUI for product inclusion] aiming to create #strong[#emph["#strong[more accessible and inclusive \[UIs for\] users of all backgrounds];".];]
- @GenerativeUIDesign2023 gives an overview of the history of generative AI design tools going back in time until 2012 when @troianoGeneticAlgorithmsSupporting2014 proposed genetic algorithms for UI design.
- @fletcherGenerativeUIDownfall2023 and @joeblairGenerativeUINew2024 are worried UIs are becoming average; that is more and more similar towards the lowest common denominator. We can generate better ones that are based on user data and would be truly personalized.
- @nielsenAccessibilityHasFailed2024 recounts how 30 years of work towards usability has largely failed - computers are still not accessible enough (#strong[#emph["difficult, slow, and unpleasant"];];) - and has hope Generative UI could offer a chance to provide levels of accessibility humans could not.
- @matteosciortinoGenerativeUIHow2024 coins the phrase RTAG UIs #emph["real-time automatically-generated UI interfaces"] mainly drawing from the example of how his Netflix interface looks different from that of his sisters because of their dissimilar usage patterns.
- @NielsenIdeasGenerative2024 Meanwhile is very critical because for the following reasons:

#figure(
  align(center)[#table(
    columns: (28.17%, 71.83%),
    align: (auto,auto,),
    table.header([Problem], [Description],),
    table.hline(),
    [Low predictability], [Does personalization mean the UI keeps changing?],
    [High carbon cost], [AI-based personalization is computation-intensive],
    [Surveillance], [Personalization needs large-scale data capture],
  )]
  , caption: [Criticism of Generative UI by @NielsenIdeasGenerative2024.]
  , kind: table
  )

What is the user interface of the green transformation?

- #cite(<katemoranGenerativeUIOutcomeOriented2024>, form: "prose") "highly personalized, tailor-made interfaces that suit the needs of each individual" "Outcome-Oriented Design"

#cite(<mckeoughMcKinseyDesignLaunches2018>, form: "prose") business consultancies have begun to recognize the importance of design to business. They advise their corporate clients to bring user experience design to the core of their business operations.

There’s a number of user interface design patterns that have provide successful across a range of social media apps. Such #strong[#emph[user experience / user interface];] (UX/UI) patterns are copied from one app to another, to the extent that the largest apps share a similar look and feature set. Common UX/UI parts include the Feed and Stories. By using common UI parts from social media users have an easier time to accept the innovative parts. add Viz charts. Avatars are increasingly common and new generations are used to talking to computers.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Feature], [Examples], [],),
    table.hline(),
    [Feed], [], [],
    [Post], [Apple App Store], [],
    [Stories], [IG, FB, WhatsApp, SnapChat, TikTok], [],
    [Comment], [], [],
    [Reactions], [], [],
  )]
  , caption: [Common Social Media UI Parts]
  , kind: table
  )

There are also more philosophical approaches to #strong[#emph[Interface Studies:];] #cite(<davidhoangCreatingInterfaceStudies2022>, form: "prose");, the head of product design at Webflow, suggests taking cues from art studies to #strong[#emph[isolate the core problem];];: #emph["An art study is any action done with the intention of learning about the subject you want to draw"];. As a former art student, Hoang looks at an interface as #emph["a piece of design is an artwork with function"];.

Indeed, art can be a way to see new paths forward, practicing "#emph[fictioning];" to deal with problematic legacies: #cite(<Review2023Helsinki2023>, form: "prose")

=== #strong[Interaction Design]
<interaction-design>
- Involving young HCI designers in AI-oriented workshops can show the future of UI/UX ? @battistoniCanAIOrientedRequirements2023

=== Speculative Design
<speculative-design>
Speculative design makes use of future scenarios to envision contexts and interactions in future use. The term #strong[#emph[speculative design];] was invented by #cite(<dunneSpeculativeEverythingDesign2013>, form: "prose") in their seminal book to question the intersection of user experience design and speculative fiction. For example #cite(<BARENDREGT2021374>, form: "prose") explores the potential of speculative design to stimulate public engagement through thought experiments that spur public debate on an issue chosen by the designer.

Phil Balagtas, founder of The Design Futures Initiative at McKinsey, discusses the value of building future scenarios at his talk at Google. One of his examples, the Apple Knowledge Navigator, from an Apple vision video in 1987, took two decades to materialize in the real world. It was inspired by a similar device first shown in a 1970s episode of Star Trek as a #strong[magic device] (a term from participatory design), which then inspired subsequent consumer product development. It took another 2 decades, until the launch of the iPhone in 2007 - a total of 40 years. Imagination is crucial for change @googledesignDesignSpeculativeFutures2019.

The cost of speculative design makes it into a niche activity yet Generative AI holds the promise to allow designers to dream up and prototype quicker. In order to build a future, it’s relevant to imagine and critique a future.

The same is true for Participatory Design. By being quickly generate prototypes, once can test out ideas with the future users involving more of the community and stakeholders.

=== Quantified Self
<quantified-self>
Example of quantified self device. My personal air pollution exposure tracked using the Atmotube device attached to my backpack.

- Open Source code for calculating air pollution exposure AQI: https:\/\/github.com/atmotube/aqipy

- Quantified Self is an example of Digital Health

- Tracking air pollution and realizing how bad the over in my grandma’s house is: add picture

- There is a parallel in health to sustainability and indeed both are inextricably linked.

- Use technology Wearables to be more aware of one’s health.

- EEG (brain smth), EDA (Electrodermal Activity), ECG (Electrocardiogram): tracking features of brain, heart and nervous system activity. Brain Music Lab founder and brain researcher Grace Leslie: "brain music sounds like a warm bathtub".

- Companies like NeuralLink are building devices to build meaningful interactions from brain waves (EEG).

Research on #strong[#emph[quantified self];] is abundant. Wearable devices including the Apple Watch, Oura Ring, Fitbit and others, combined with apps, help users track a variety of health metrics. Apart from health, wearable devices have been used to track other metrics such as physiological parameters of students at school to determine their learning efficiency @giannakosFitbitLearningCapturing2020.

Could one track personal sustainability in a similar fashion? @shinWearableActivityTrackers2019’s synthesis review of 463 studies shows wearable devices have potential to influence behavior change towards healthier lifestyles. #cite(<saubadePromotingPhysicalActivity2016>, form: "prose") finds health tracking is useful for motivating physical activity.

Apple is a leader in health tracking. In 2022 Apple outlined plans for #strong[#emph["empowering people to live a healthier day"];] and Apple’s HealthKit provides a growing list of health metrics, which app developers can tap into @appleEmpoweringPeopleLive2022@appleWhatNewHealthKit2022. #cite(<liuHowPhysicalExercise2019>, form: "prose") tracks how wearable data is used for tracking sleep improvements from exercise. #cite(<grigsby-toussaintSleepAppsBehavioral2017>, form: "prose") made use of sleep apps to construct humans behaviors also known as #strong[#emph[behavioral constructs];];.

- Tracking blood sugar with app and patches. Blood sugar trackers. Blood glucose tracking is popular even for people without diabetes, to optimize their activity @BloodSugarMonitoring2021..

Another aspect is tracking one’s mental health. @tylerContemporarySelfreflectivePractices2022 surveys the use of self-reflection apps in the UK (n=998).

- Popular Strava (100+ million users) sports assistant provides run tracking and feedback @stravaStravaGlobalCommunity2022.

- AI Financial Advisors will need to go further to motivate users.

- DBS digibank app added a financial advisor named "Your Financial GPS" in 2018 #cite(<dbsDBSLaunchesSingapore2018>, form: "prose")

- Tracking urine consistency inside your toilet with WithThings

- "urban metabolism" @shiUrbanInformatics2021@clairemoranWhatUrbanMetabolism2018, city in-out flows accounting method

- The urban environment has an influence on health. #cite(<delclos-alioWalkingTransportationLarge2022>, form: "prose") discusses walking in Latin American cities. Walking is the most sustainable method or transport but requires the availability of city infrastructure, such as sidewalks, which many cities still lack.

- #cite(<tsaiTranslationValidationTaiwan2019>, form: "prose")

- #cite(<burgerDevelopingSmartOperational2019>, form: "prose")

- #cite(<aromatarioHowMobileHealth2019>, form: "prose") behavior changes

- #cite(<ayoolaCHANGEPlatformServicebased2018>, form: "prose") wellbeing data

- #cite(<godfreyWearableTechnologyExplained2018>, form: "prose")

- #cite(<thomasExploringDigitalRemediation2018>, form: "prose")

- #cite(<tonneNewFrontiersEnvironmental2017>, form: "prose")

- #cite(<anselmaArtificialIntelligenceFramework2017>, form: "prose")

- #cite(<forlanoPosthumanismDesign2017>, form: "prose") post-humanism and design

- #cite(<greenbaumWhoOwnsYour2016>, form: "prose")

- #cite(<millingsCanEffectivenessOnline2015>, form: "prose")

- #cite(<reisIntegratingModellingSmart2015>, form: "prose")

- #cite(<bowerWhatAreEducational2015>, form: "prose")

- #cite(<fletcherFriendlyNoisySurveillance2022>, form: "prose")

- #cite(<ryanEthicsDietaryApps2022>, form: "prose") uses the "capability methodology" to evaluate if apps help people eat healthily.

- #cite(<baptistaSystematicReviewSmartphone2022>, form: "prose") apps for sleep apnea

=== Digital Sustainability
<digital-sustainability>
In digital sustainability, information pertaining to emissions would flow through the economy not unlike the carbon cycle itself.

- #cite(<panArtificialIntelligenceDigital2023>, form: "prose") important

=== Digital Product Design
<digital-product-design>
Design is as much about how it works as it’s about the interface.

Digital product design can be seen as a specific discipline under the umbrella of #strong[Experience Design];. In #cite(<michaelabrashInventingFuture2017>, form: "prose") Meta Oculus augmented reality incubation general manager Laura Fryer: #emph["People buy experiences, not technology."]

Young people expect a product. Intelligent Interfaces use interaction design to provide relevant and personalized information in the right context and at the right time.

#cite(<ceschinEvolutionDesignSustainability2016>, form: "prose") shows how design for sustainability has expanded from a product focus to systems-thinking focus placing the product inside a societal context of use. For example #cite(<CargoBikeFREITAG>, form: "prose");, recycled clothing maker FREITAG offers sustainability-focused services such ass cargo bikes so you can transport your purchases and a network for #emph[shopping without payment] = swapping your items with other members, as well as repairs of their products. Loaning terminology from #strong[#emph[service design];];, the user journey within an app needs to consider each touchpoint on the way to a state of success.

#cite(<weinschenk100ThingsEvery2011>, form: "prose") says #emph["People expect most online interactions to follow the same social rules as person-to-person interactions. It’s a shortcut that your brain uses to quickly evaluate trustworthiness."]

The small screen estate space of mobiles phones and smart watches necessitates displaying content in a dynamic manner. Virtual reality glasses (called AR/VR or XR in marketing speak) need dynamic content because the user is able to move around the environment. These are questions that interaction design is called upon to solve. #cite(<hoangEnterDynamicIsland2022>, form: "prose");: #emph["Dynamic interfaces might invoke a new design language for extended reality".]

The promise of #strong[#emph[Generative UI];] is to dynamically provide an interface appropriate for the particular user and context.

Speaking is one mode of interaction that’s become increasingly possible as machines learn to interpret human language.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Mode of Interaction], [],),
    table.hline(),
    [Writing], [],
    [Speaking], [],
    [Touching], [],
    [Moving], [],
    [], [],
  )]
  , caption: [Modes of interaction]
  , kind: table
  )

Coputer

Humans respond well to #strong[#emph[storytelling];];, making #strong[#emph[character design];] and #strong[#emph[narrative design];] relevant to interaction design. Large language models (LLMs) such as ChatGPT are able to assume the personality of any character that exists inside of its training data, creating opportunities for automated narrative design.

One mode

- #cite(<koningsHowPrepareYour2020>, form: "prose")
- "Digital sustainability principles"
- Eminent journal Design Studies, 1st design journal
- Part of digital product design are #strong[design systems] to keep consistency across the experience. Create a design system to best to showcase my analytic skills:
  - Design System: https:\/\/zeroheight.com/8bf57183c/p/82fe98-introduction
  - #cite(<ComprehensiveGuideDesign>, form: "prose")
  - #cite(<suarezDesignSystemsHandbook>, form: "prose")
  - #cite(<MethodPodcastEpisode>, form: "prose")
  - #cite(<AtomicDesignBrad>, form: "prose")
- #cite(<kolkoThoughtsInteractionDesign2010>, form: "prose") and #cite(<ixdfWhatInteractionDesign>, form: "prose") believe interaction design is still an emerging (and changing) field and there are many definitions. I prefer the simplest version: interaction design is about creating a conversation between the product and the user.
- AI gives designers new tools. In AI development, design is called alignment. What is the role of an AI Designer? #cite(<lindenWhatRoleAI2021>, form: "prose")
- #cite(<PeopleAIGuidebook>, form: "prose")
- #cite(<LanguageModelSketchbook>, form: "prose")
- #cite(<parundekarEssentialGuideCreating2021>, form: "prose")
- #cite(<richardyangInteractionDesignMore2021>, form: "prose") and #cite(<justinbakerRedRoutesCritical2018>, form: "prose") say some of the tools used by interaction designers include
- AI for design: #cite(<figmaAINextChapter2023>, form: "prose")

The concept of #strong[#emph[Social Objects];] is People need something to gather around and discuss. #cite(<labWhatSocialObject2015>, form: "prose");: I’m interested in the concept of a "social object".

#strong[#emph[Red Route Analysis];] is an user experience optimization idea inspired by the public transport system of London (#cite(<oviyamtmRedRouteApplication2019>, form: "prose");; #cite(<InteractionDesignHow2021>, form: "prose") and #cite(<xuanHowPrioritiseProduct2022>, form: "prose");).

Large Digital Platforms have a very small number of workers relative to the number of users they serve. This creates the necessity for using automation for both understanding user needs and providing the service itself. Creating a good product that’s useful for the large majority of users depends on #strong[#emph[Data-Driven Design.];]

- Product marketers focus on the #strong[#emph[stickiness];] of the product, meaning low attrition, meaning people keep coming back.
- What percent of all design is "sustainable design" ? Promoting sustainable design.
- #cite(<joshluberTradingCardsAre2021>, form: "prose") Trading cards are cool again
- #cite(<jesseeinhornNewBalance6502020>, form: "prose")
- #cite(<connieloizosMarcyVenturePartners2021>, form: "prose")
- #cite(<natashamascarenhasQueenlyMarketplaceFormalwear2021>, form: "prose")
- #cite(<jeffjohnrobertsDigitalArtAwaits2020>, form: "prose")

=== Narrative Design
<narrative-design>
- The rising availability of AI assistants may displace Google search with a more conversational user experience. Google itself is working on tools that could cannibalize their search product. The examples include Google Assistant, Google Gemini (previously known as Bard) and large investments into LLMs.

- #cite(<aletheaaiAletheaAIAI2021>, form: "prose");: discusses writing AI Characters, creating a personality.

- Writing as training data? large language models. GTP3.

- Stories start with a character.

=== Behavioral Design
<behavioral-design>
For decades, marketers and researchers have been researching how to affect human behavior towards increasing purchase decisions in commerce, both offline and online, which is why the literature on behavioral design is massive. One of the key concepts is #emph[nudge];, first coined in 2008 by the Nobel-winning economist Richard Thaler; nudges are based on a scientific understanding of human psychology and shortcuts and triggers that human brains use and leverages that knowledge to influence humans in small but powerful ways @thalerNudgeImprovingDecisions2009.

The principles of nudge have also been applied to sustainability. For example, a small study (n=33) in the Future Consumer Lab in Copenhagen by #cite(<perez-cuetoNudgingPlantbasedMeals2021>, form: "prose") found that designing a "dish-of-the-day" which was prominently displayed helped to increase vegetarian food choice by 85%. #cite(<GUATH2022101821>, form: "prose") experiments (n=200) suggested nudging can be effective in influencing online shopping behavior towards more sustainable options. A larger scale study of behavior change in Australia maps how to avoid "16 billion paper coffee cups are being thrown away every year" @novoradovskayaMyCupTea2021.

Google uses nudges in Google Flights and Google maps, which allow filtering flights and driving routes by the amount of CO#sub[2] emissions, as well as surfacing hotels with Green Key and EarthCheck credentials, while promising new sustainability features across its portfolio of products #cite(<sundarpichaiGivingYouMore2021>, form: "prose");. Such tools are small user interface nudges which Google’s research calls #emph[digital decarbonization];, defined by #cite(<implementconsultinggroupHowDigitalSector2022>, form: "prose") as "Maximising the enabling role of digital technologies by accelerating already available digital solutions".

In #cite(<katebrandtGoogleClimateAction2022>, form: "prose");, Google’s Chief Sustainability Officer Kate Brandt set a target of "at least 20-25%" CO#sub[2] emission reductions in Europe to reach a net-zero economy and the global announcement set a target of helping 1 billion people make more sustainable choices around the world @jenimilesBecomingSustainabilityAwareApp2022. In addition to end–users, Google offers digital decarbonization software for developers, including the Google Cloud Carbon Footprint tool and invests in regenerative agriculture projects @GoogleRegenerativeAgriculture2021@googleCarbonFootprint2023.

#cite(<sarahperezGoogleRollsOut2022>, form: "prose") shows how google added features to Flights and Maps to filter more sustainable options

#cite(<justinecalmaGoogleLaunchesNew2021>, form: "prose") Google UX eco features

How CO2 is shown by Google starts hiding emissions? #cite(<GoogleAirbrushesOut2022>, form: "prose")

Google VERY IMPORTANTT #cite(<googleGoogleSustainabilityHelping2021>, form: "prose")

#cite(<GoogleMostraraPor2021>, form: "prose") Google green routes

Wizzair Check carbon impact #cite(<OffsetYourFlight>, form: "prose")

#figure(
  align(center)[#table(
    columns: (47.22%, 26.39%, 26.39%),
    align: (auto,auto,auto,),
    table.header([Feature], [Product], [Nudge],),
    table.hline(),
    [Google Maps AI suggests more eco-friendly driving routes #cite(<mohitmoondraNavigateMoreSustainably>, form: "prose");], [Google Maps], [Show routes with lower CO#sub[2] emissions],
    [Google Flights suggests flights with lower CO#sub[2] emissions], [Google Flights], [Show flights with lower CO#sub[2] emissions],
  )]
  , caption: [Examples of CO#sub[2] visibility in Google’s products.]
  , kind: table
  )

- The founder of the Commons (Joro) consumer CO#sub[2] tracking app recounts how people have a gut feeling about the 2000 calories one needs to eat daily and daily CO#sub[2] tracking could develop a gut feeling about one’s carbon footprint @jasonjacobsEpisodeSanchaliPal2019.

Some notable examples:

- #cite(<ERIKSSON2023229>, form: "prose") discusses best practices for reducing food waste in Sweden.
- #cite(<ACUTI2023122151>, form: "prose") makes the point that physical proximity to a drop-off point helps people participate in sustainability.
- #cite(<WEE2021100364>, form: "prose") proposes types of nudging technique based on an overview of 37 papers in the field.

#figure(
  align(center)[#table(
    columns: (36.11%, 63.89%),
    align: (auto,auto,),
    table.header([Name], [Technique],),
    table.hline(),
    [Prompting], [Create cues and reminders to perform a certain behavior],
    [Sizing], [Decrease or increase the size of items or portions],
    [Proximity], [Change the physical (or temporal) distance of options],
    [Presentation], [Change the way items are displayed],
    [Priming], [Expose users to certain stimuli before decision-making],
    [Labelling], [Provide labels to influence choice (for example CO#sub[2] footprint labels)],
    [Functional Design], [Design the environment and choice architecture so the desired behavior is more convenient],
  )]
  , caption: [Types of nudge by #cite(<WEE2021100364>, form: "prose");]
  , kind: table
  )

- #cite(<bainPromotingProenvironmentalAction2012>, form: "prose") "Promoting pro-environmental action in climate change deniers" #strong[(Need access!)]
- #cite(<allcottSocialNormsEnergy2011>, form: "prose") "Social norms and energy conservation" #strong[(Need access!, ncku doesn’t subscribe)]
- #cite(<schuitemaAcceptabilityEnvironmentalPolicies2018>, form: "prose") "Acceptability of Environmental Policies" #strong[(Need access!)]
- #cite(<nilssonRoadAcceptanceAttitude2016>, form: "prose") "The road to acceptance: Attitude change before and after the implementation of a congestion tax" #strong[(Need access!)]
- #cite(<BERGER2022134716>, form: "prose") #strong[(Need access!)]
- #cite(<SupportCleanEnergy2022>, form: "prose")
- #cite(<UNCTADWorldInvestmentReport2023>, form: "prose")
- #cite(<climatiqClimatiqCarbonEmissions2023>, form: "prose") Automate GHG emission calculations
- #cite(<earthcheckEarthCheckGoodBusiness2023>, form: "prose") sustainable tourism certification
- #cite(<lfcaLeadersClimateAction2023>, form: "prose") corporate climate action
- #cite(<greenhousegasprotocolHomepageGHGProtocol2023>, form: "prose") standards to measure and manage emissions
- #cite(<playingfortheplanetalliancePlayingPlanetAnnual2021>, form: "prose")

==== Gamification
<gamification>
- Gamification makes uses of nudges.

- Students in Indonesia enjoy using Kahoot and it’s gamification elements are perceived to have positive impact on individual learning outcomes so they are happy to continue using it @wiraniEvaluationContinuedUse2022.
- #cite(<SpaceApeGames>, form: "prose") game company going green
- Alibaba’s Ant Forest (螞蟻森林) has shown the potential gamified nature protection, simultaneously raising money for planting forests and building loyalty and brand recognition for their sustainable action, leading the company to consider further avenues for gamification and eco-friendliness.

#figure(
  align(center)[#table(
    columns: (8.57%, 18.57%, 18.57%, 54.29%),
    align: (auto,auto,auto,auto,),
    table.header([Year], [Users], [Trees], [Area],),
    table.hline(),
    [2016], [?], [0], [],
    [2017], [230 million], [10 million], [],
    [2018], [350 million], [55 million], [6500 acres??],
    [2019], [500 million], [100 million], [112,000 hectares / 66, 000 hectares?],
    [2020], [550 million], [200 million], [2,7 million acres?],
    [2021], [600 million], [326 million], [],
    [2022], [650 million], [400 million], [2 million hectares],
    [], [], [], [],
    [], [], [], [],
  )]
  , caption: [Table of Ant Forest assisted tree planting; data compiled from @ZhuZiXun2017@yangSwitchingGreenLifestyles2018@unfcccAlipayAntForest2019@wangFuelingProEnvironmentalBehaviors2020@600MillionPeople2021@zhangPromoteProenvironmentalBehaviour2022@wangMotivationsInfluencingAlipay2022@zhouUnpackingEffectGamified2023@caoImpactArtificialIntelligence2023.]
  , kind: table
  )

#box(image("_thesis_files/figure-typst/cell-4-output-1.svg"))

== Data-Driven Design Enables Sustainability
<data-driven-design-enables-sustainability>
Sustainability touches every facet of human existence and is thus an enormous undertaking. Making progress on sustainability is only possible if there’s a large-scale coordinated effort by humans around the planet. For this to happen, appropriate technological tools are required.

=== Life-Centered Design
<life-centered-design>
#strong[#emph[Life-Centered Design];] recognizes human impact on our surrounding environment as well as other animals making sure to include them among stakeholders While #strong[#emph[Human-Centered Design];] has become popular, the effect humans are having on biodiversity should be considered when designing. #emph["\[T\]he design phase of a physical product accounts for 80% of its environmental impact"] notes@borthwickHumancentredLifecentredDesign2022 in their framework for life-centered design.

- #cite(<sanchezGreenBearLoRaWANbased2022>, form: "prose") LoRaWAN

=== Interaction Design for Climate Change
<interaction-design-for-climate-change>
Interaction Design for Climate Change: how can we change common UIs so they take into account sustainability?

Popular blogs such as @kohliHowDesignersCan2019 and @loseWaysUXDesign2023 offer many suggestions how designers can help people become more sustainable in their daily lives yet focusing on the end-user neglects the producers’ responsibility (termed as Extended Producer Responsibility or ERP) in waste management studies.

- #cite(<uiaworldcongressofarchitectsDesignClimateAdaptation2023>, form: "prose") "Design for climate adaptation"
- #cite(<andrewchaissonHowFightClimate2019>, form: "prose")
- #cite(<dzigajevHowCanWe2019>, form: "prose")
- #cite(<mankoffEnvironmentalSustainabilityInteraction2007>, form: "prose")
- #cite(<borthwickHumancentredLifecentredDesign2022>, form: "prose")
- #cite(<loseUsingMySkills2023>, form: "prose") is worried about applying UX skills for Climate Change

==== Tracking Transport
<tracking-transport>
Products are made from resources distributed across the planet and transported to clients around the world which currently causes high levels (and increasing) of greenhouse gases. #emph["Transport greenhouse gas emissions have increased every year since 2014"] @ClimateChangeMitigation2023. Freight (transport of goods by trucks, trains, planes, ships) accounts for 1.14 gigatons of CO#sub[2] emissions as per 2015 data or 16% of total international supply chain emissions @wangVolumeTradeinducedCrossborder2022.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Type of Transport], [Percentage],),
    table.hline(),
    [Passenger cars], [39%],
    [#strong[Medium and heavy trucks];], [23%],
    [#strong[Shipping];], [11%],
    [#strong[Aviation];], [9%],
    [Buses and minibuses], [7%],
    [Light commercial vehicles], [5%],
    [Two/three-wheelers], [3%],
    [Rail], [3%],
  )]
  , caption: [Share of CO#sub[2] of CO#sub[2] emissions by type of transport globally @statistaGlobalTransportCO22022.]
  , kind: table
  )

- #cite(<platzerPerspectiveUrgencyGreen2023>, form: "prose");, a scientist working on the Apollo space program, calls for emergency action to develop #emph[green aviation];.

- The California Transparency in Supply Chains Act which came into effect in 2012 applies to large retailers and manufacturers focused on pushing companies to to eradicate human trafficking and slavery in their supply chains.

- The German Supply Chain Act (Gesetz über die unternehmerischen Sorgfaltspflichten zur Vermeidung von Menschenrechtsverletzungen in Lieferketten) enacted in 2021 requires companies to monitor violations in their supply chains @Lieferkettengesetz2023@strettonGermanSupplyChain2022.

==== Tracing Supply Chains
<tracing-supply-chains>
Circular design is only possible if supply chains become circular as well.

It’s important in which structure data is stored, affecting the ability to efficiently access and manage the data while guaranteering a high level of data integrity, security, as well as energy usage of said data.

The complexity of resource and delivery networks necessitates more advanced tools to map supply chains @knightFutureBusinessRole2022. The COVID19 pandemic and resulting blockages in resource delivery highlighted the need to have real-time visibility into supply chains @finkenstadtBlurryVisionSupply2021.

Blockchains are a special type of database where the data is stored in several locations with a focus on making the data secure and very difficult to modify after it’s been written to the database. Once data is written to the blockchain, modifying it would require changing all subsquent records in the chain and agreement of the majority of validators who host a version of the database.

Blockchain is the main technology considered for accounting for the various inputs and complex web of interactions between many participants inside the supply chain networks. There are hundreds of paper researching blockchain use in supply change operations since 2017 @duttaBlockchainTechnologySupply2020. Blockchains enable saving immutable records into distributed databases (also known as ledgers). It’s not possible to (or extremely difficult) to change the same record, only new records can be added on top of new ones. Blockchains are useful for data sharing and auditing, as the time and place of data input can be guaranteed, and it will be easier to conduct a search on who inputted incorrect data; however the system still relies on correct data input. As the saying goes, #emph["garbage in, garbage out"];.

There are several technologies for tracking goods across the supply chain, from shipping to client delivery. Data entry is a combination of manual data input and automated record-keeping facilitated by sensors and integrated internet of things (IoT) capabilities. For example @ashrafPrototypeSupplyChain2023 describes using the Solana blockchain and Sigfox internet of things (IoT) Integration for supply chain traceability where Sigfox does not need direct access to internet but can send low powered messages across long distances (for example shipping containers on the ocean). @vanwassenaerTokenizingCircularityAgrifood2023 compares use cases for blockchains in enhancing traceability, transparency and cleaning up the supply chain in agricultural products.

- Several startups are using to track source material arriving to the factories and product movements from factories to markets.

- #cite(<wagenvoortSelfdrivingSupplyChains2020>, form: "prose") Self-driving supply chains.. (contact Japanese factory?)

#figure(
  align(center)[#table(
    columns: (24.66%, 24.66%, 26.03%, 24.66%),
    align: (auto,auto,auto,auto,),
    table.header([Company], [Link], [Literature], [Comments],),
    table.hline(),
    [Ocean Protocol], [oceanprotocol.com], [], [],
    [Provenance], [provenance.io], [], [],
    [Ambrosius], [ambrosus.io], [], [],
    [Modum], [modum.io], [], [],
    [OriginTrail], [origintrail.io], [], [],
    [Everledger], [everledger.io], [], [],
    [VeChain], [vechain.org], [], [],
    [Wabi], [wabi.io], [], [],
    [FairFood], [fairfood.org], [], [],
    [Bext360], [bext360.com], [], [],
    [SUKU], [suku.world], [#cite(<millerCitizensReserveBuilding2019>, form: "prose") SUKU makes supply chains more transparent], [Seems to have pivoted away from supply chains],
  )]
  , caption: [Blockchain supply chain companies as of summer 2023 include.]
  , kind: table
  )

==== Ethics & Cruelty
<ethics-cruelty>
Can data transparency provide tools for reducing cruelty.

- Traceability and animal rights. Animal rights vs animal welfare. Ethereum blockchain and animal rights. "Blockchain can provide a transparent, immutable record of the provenance of products. This can be especially useful for verifying claims made about animal welfare. For example, products claiming to be"free-range,” "organic," or "sustainably sourced" could have their entire lifecycle recorded on the blockchain, from birth to shelf, allowing consumers to verify these claims.”

- Cruelty free brands

- BCorp

- ESG

- Trash found in ocean / nature etc

- Increase your investment point by matching with your contribution /.

- Point of Sales integration (know the SKU you buy). Integrate to the financial eco footprint (no need to scan the product). What’s the name of the startup that does this?

- Precision Fermentation and Cultivated Meat: Meat products without farm animals

==== Open Data
<open-data>
- Taiwan is a proponent of Open Gov OP-MSF OGP @opengovernmentpartnershipOGPParticipationCoCreation2021@labTaiwanTakesActions2021

Data-driven design requires access to data, making the movement towards #emph[open data sharing] very important. Some countries and cities are better than others at sharing data openly.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Country], [Project], [Reference],),
    table.hline(),
    [Sweden], [Swedish open data portal], [#cite(<SverigesDataportal>, form: "prose");],
    [], [], [],
    [], [], [],
  )]
  , caption: [Examples of cities and countries that share data openly.]
  , kind: table
  )

- When will Bolt show CO#sub[2] emissions per every trip?
- Sustainable finance data platform:
- #cite(<wikirateWebinarEnvisioningFinding2021>, form: "prose") WikiRate defines Data Sharing Archetypes

#figure(
  align(center)[#table(
    columns: (47.22%, 52.78%),
    align: (auto,auto,),
    table.header([Type], [Example],),
    table.hline(),
    [Transparency Accountability Advocate], [],
    [Compliance Data Aggregator], [],
    [Data Intelligence Hub], [],
    [Worker Voice Tool], [#cite(<caravanstudiosStrengthenYourWorker2022>, form: "prose");: #strong["Worker Connect"];],
    [Traceability tool], [trustrace.com],
    [Open data platform], [],
    [Knowledge sharing platform], [business-humanrights.org],
  )]
  , kind: table
  )

- WikiRate is a tool for checking green credentials Transparency
- #cite(<laureenvanbreenPanelScalingCorporate2023>, form: "prose")
- #cite(<wikirateIntroducingFacilityChecker2022>, form: "prose")
- #cite(<HomeChainReact>, form: "prose")

==== Taxes
<taxes>
- There have been proposal of a "meat tax".

==== Carbon Labels
<carbon-labels>
Adding CO#sub[2] labels for consumer products have been discussed for decades @adamcornerWhyWeNeed2012. #cite(<cohenPotentialRoleCarbon2012>, form: "prose") argues carbon labels do influence consumer choice towards sustainability. Academic literature has looked at even minute detail such as color and positioning of the label (#cite(<zhouCarbonLabelsHorizontal2019>, form: "prose");). There is some indication consumers are willing to pay a small premium for low-CO#sub[2] products (#cite(<xuLowcarbonEconomyCarbon2022>, form: "prose");). All else being equal, consumers choose the option with a lower CO#sub[2] number (#cite(<carlssonSustainableFoodCan2022>, form: "prose");). Nonetheless, the idea of #emph[Carbon Labelling] is yet to find mainstream adoption.

There’s some evidence to suggest labeling low CO#sub[2] food enables people to choose a #emph[climatarian diet] in a large-scale study #cite(<lohmannCarbonFootprintLabels2022>, form: "prose") of UK university students, however the impact of carbon labels on the market share of low-carbon meals is negligible. Labels alone are not enough. underlines #cite(<edenbrandtConsumerPerceptionsAttitudes2022>, form: "prose") in Sweden in a study which found a negative correlation between worrying about climate impact and interest in climate information on products; this finding may be interpreted suggesting a need for wider environmental education programs. #cite(<asioliConsumersValuationCultured2022>, form: "prose") found differences between countries, where Spanish and British consumers chose meat products with #emph['No antibiotics ever'] over a #emph[Carbon Trust] label, whereas French consumers chose CO#sub[2] labeled meat products.

Carbon labeling is voluntary and practiced by only a handful of companies. The U.S. restaurant chain #emph[Just Salad] , U.K.-based vegan meat-alternative #emph[Quorn] and plant milk #emph[Oatly] are some example of companies that provide carbon labeling on their products @briankatemanCarbonLabelsAre2020. #cite(<climatepartnerLabellingCarbonFootprint2020>, form: "prose");: Companies like ClimatePartner and Carbon Calories offers labeling consumer goods with emission data as a service. #cite(<thecarbontrustHowReduceYour>, form: "prose");: The Carbon Trust reports it’s certified 27 thousand product footprints.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Company], [Country],),
    table.hline(),
    [Just Salad], [U.S.A.],
    [Quorn], [U.K.],
    [Oatly], [U.K.],
  )]
  , caption: [Companies with Carbon Labels @briankatemanCarbonLabelsAre2020]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Organization], [Country], [Number of Product Certified],),
    table.hline(),
    [ClimatePartner], [], [],
    [Carbon Calories], [], [],
    [Carbon Trust], [], [27000],
  )]
  , caption: [Organization to Certify Carbon Labels @climatepartnerLabellingCarbonFootprint2020.]
  , kind: table
  )

- Digitalisation and digital transformation; Digital Receipts are one data source for tracking one’s carbon footprint @DigitalReceiptsCustomer.

- #cite(<ivanovaQuantifyingPotentialClimate2020>, form: "prose") "establish consumption options with a high mitigation potential measured in tonnes of CO#sub[2] equivalent per capita per year."

- 55% of emissions come from energy production.

- 1.7 trillion tons of CO2e emissions since the 1760s (start of the industrial revolution) @globalcarbonbudgetCumulativeCOEmissions2023@marvelOpinionClimateScientist2023.

- #cite(<cartoClimateResilienceGeography2023>, form: "prose") Making advanced maps to convince people to make changes

- similar to Nutritional Facts Labeling

==== Digital Product Passports
<digital-product-passports>
- Circularise has been working on a blockchain-based sustainability solution since 2016 and is the market leader providing Digital Product Passports for improving transparency across several industries #cite(<strettonDigitalProductPassports2022>, form: "prose") "Ecodesign for Sustainable Products Regulation (part of the Sustainable Products Initiative) and one of the key actions under the Circular Economy Action Plan (CEAP). The goal of this initiative is to lay the groundwork for a gradual introduction of a digital product passport in at least three key markets by 2024" "Connecting the Value Chain, One Product at a Time" "Circularise aims to overcome the communication barrier that is limiting the transition to a circular economy with an open, distributed and secure communications protocol based on blockchain technology."
- product’s history, composition, and environmental impact.

#figure(
  align(center)[#table(
    columns: (70.83%, 29.17%),
    align: (auto,auto,),
    table.header([Goal], [Description],),
    table.hline(),
    [#strong[Sustainable Product Production];], [],
    [#strong[Businesses to create value through Circular Business Models];], [],
    [#strong[Consumers to make more informed purchasing decisions];], [],
    [#strong[Verify compliance with legal obligations];], [],
  )]
  , caption: [Digital Product Passport goals #cite(<strettonDigitalProductPassports2022>, form: "prose");]
  , kind: table
  )

Digital product passports are a further development of the idea of carbon labels.

- The European Commision has proposed a #emph[Digital Product Passports] to help companies transfer environmental data @nissinenMakeCarbonFootprints2022. Carbon labels are needed for green transformation.

- #cite(<reichDefiningGoalsProduct2023>, form: "prose") "Information gaps are identified as one of the major obstacles to realizing a circular economy."

- #cite(<jensenDigitalProductPassports2023>, form: "prose") "support decision-making throughout product life cycles in favor of a circular economy."

- #cite(<kingProposedUniversalDefinition2023>, form: "prose") "influence consumer behavior towards sustainable purchasing and responsible product ownership by making apparent sustainability aspects of a product life cycle."

- #cite(<bergerConfidentialitypreservingDataExchange2023>, form: "prose") "support Sustainable Product Management by gathering and containing product life cycle data. However, some life cycle data are considered sensitive by stakeholders, leading to a reluctance to share such data."

- #cite(<plociennikDigitalLifecyclePassport2022>, form: "prose") "Digital Lifecycle Passport (DLCP) hosted on a cloud platform and can be accessed by producers, users, recyclers"

- #cite(<bergerFactorsDigitalProduct2023>, form: "prose") challenges with Electric Vehicle Batterys. #cite(<bergerDataRequirementsAvailabilities2023>, form: "prose") proposes Digital Battery Passports

- #cite(<vancapelleveenAnatomyPassportCircular2023>, form: "prose") literature overview

- Sustainable Product Management: #cite(<korzhovaSustainableProductManagement2020>, form: "prose")

- What data does a digital product passport hold? #cite(<tiandaphneWhatDataGoes2023>, form: "prose")

- #cite(<gitcoinpassport2023>, form: "prose") discusses ow to build an antifragile scoring system (antifragile passport) inspired by Nassim Taleb’s popular book that discusses antifragile systems that get better in difficult situations @talebAntifragileThingsThat2012.

== Re-Designing Industries for Provenance and Traceability
<re-designing-industries-for-provenance-and-traceability>
It’s possible to re-design entire industries and that is exactly the expectation sustainability sets on businesses. Across all industries, there’s a call for more transparency. Conversations about sustainability are too general and one needs to look at the specific sustainability metrics at specific industries to be able to design for meaningful interaction. There’s plentiful domain-specific research showing how varied industries can develop eco-designed products. I will here focus on 2 industries that are relevant for college students.

=== Sustainable Fashion
<sustainable-fashion>
Young people are the largest consumers of fast fashion @YoungConsumersComplicated. @europeanenvironmentagencyTextilesEnvironmentRole2022[ European Environment Agency (EEA)] estimates based on trade and production data that EU27 citizens consumed an average 15kg of textile products per person per year.

- Better Cotton Initiative #link("https://bettercotton.org/")[https:\/\/bettercotton.org/https:\/\/bettercotton.org/]

Sustainable Fashion, Textile Design

- There are signs of young Chinese consumers valuing experiences over possessions @jiangHowHaveCovid2023.

- #cite(<millward-hopkinsMaterialFlowAnalysis2023>, form: "prose") shows how half of the textile waste in the UK is exported to other countries.

- Story of Patagonia #cite(<chouinardLetMyPeople2005>, form: "prose")

Across industries, reports are saying there isn’t enough transparency.

- @hannahritchieSectorSectorWhere2020@usepaGlobalGreenhouseGas2016 GHG emission inventory by sector

- #strong[Problem];: #cite(<emilychanWeStillDon2022>, form: "prose") report says there’s not enough transparency in fashion:

- Fashion greenwashing, fashion is 2%-8% of total GHG emissions, 2.4 Trillion USD industry, 100B USD lost to lack of recycling, contributes 9% of microplastics: #cite(<adamkiewiczGreenwashingSustainableFashion2022>, form: "prose")

- #cite(<centobelliSlowingFastFashion2022>, form: "prose") per year uses 9B cubic meters of water, 1.7B tonnes of CO#sub[2];, 92 million tonnes of textile waste.

- #cite(<kohlerCircularEconomyPerspectives2021>, form: "prose");: Globally 87% of textile products are burned or landfilled after 1st consumer use.

- #cite(<marrucciImprovingCarbonFootprint2020>, form: "prose") Italian retail supermarkets carbon footprint?

- #cite(<leungGreenDesign2021>, form: "prose") There’s a growing know-how on how to produce sustainably and which materials to use. "Handbook of Footwear Design and Manufacture" Chapter 18~-~Green design.

- #cite(<emilychanWill2022Be2022>, form: "prose") New Standard Institute’s proposed "Fashion Act" to require brands doing business in New York City to disclose sustainability data and set waste reduction targets.

- #cite(<wikirateSharingDataCreating2022>, form: "prose");: "Among the Index’s main goals are to help different stakeholders to better understand what data and information is being disclosed by the world’s largest fashion brands and retailers, raise public awareness, educate citizens about the social and environmental challenges facing the global fashion industry and support people’s activism."

- #cite(<mabuzaNaturalSyntheticDyes2023>, form: "prose") shows consumer knowledge of apparel coloration is very limited.

- #cite(<gyabaahCharacterizationDumpsiteWaste2023>, form: "prose") research across several dumpsites across Ghana revealed up to 12% of the landfill consisted of textile waste.

- #cite(<imperfectidealistSustainableGreenwashingHow2020>, form: "prose") Fashion sustainability vs greenwashing

- #cite(<TransparencySustainabilityPlatform2023>, form: "prose") Ethical Shopping

- #cite(<SheepIncSoftcore2023>, form: "prose") Ethical brand?

- #cite(<goodonyouGoodYouSustainable2023>, form: "prose") Sustainable fashion company evaluations

- #cite(<LilyMindfulActive>, form: "prose") Garment Worker’s rights

- #cite(<emilychanWillFashionIndustry2022>, form: "prose");: fashion companies can’t be held accountable for their actions (or indeed, their lack of action).

- #cite(<wikirateWikiRate2023>, form: "prose")

- #cite(<InstantGratificationCollective2022>, form: "prose");: "Political consumerism", "Instant Gratification for Collective Awareness and Sustainable Consumerism"

- #cite(<fashioncheckerFashionCheckerWagesTransparency2023>, form: "prose")

- #cite(<eestidisainikeskusiestoniandesigncentreCircularDesignHOW2021>, form: "prose") Circular textiles

- #cite(<eestikunstiakadeemiaEKAArendasEuroopa2022>, form: "prose") Sustainable Fashion education

- #cite(<fashionrevolutionfoundationFASHIONTRANSPARENCYINDEX2022>, form: "prose") Fashion transparency index

- #cite(<CleanClothesCampaign>, form: "prose")

- "The mainstream fashion industry is built upon the exploitation of labor, natural resources and the knowledge of historically marginalized peoples."

- #cite(<TextileGenesis>, form: "prose")

- "Secrecy is the linchpin of abuse of power…its enabling force. Transparency is the only real antidote." Glen Greenwald, Attorney and journalist.

- #cite(<stand.earthStandEarthPeople2023>, form: "prose")

- #cite(<NewStandardInstitute>, form: "prose")

- #cite(<BGMEAHome>, form: "prose") Bangladesh Garment Manufacturers and Exporters Association

- #cite(<errKomisjonTahabVahendada2022>, form: "prose") European Commission wants to reduce the impact of fast fashion on EU market.

- Minimize shopping, buy quality, save CO#sub[2];, invest.

- #cite(<textileexchangeTextileExchange2023>, form: "prose") Ethical fashion materials matter

- #cite(<textileexchangeFASHIONINDUSTRYTRADE2021>, form: "prose");: Policy request

- Free clothes

- #cite(<vanishukGENERATIONREWEARFull2021>, form: "prose") "Generation rewear" documentary, sustainable fashion brands

- #cite(<storbeckFastFashionMust2021>, form: "prose") and #cite(<remingtonZalandoZignLabel2020>, form: "prose");: Zalando says Fast fashion must disappear

- #cite(<infinitedfiberInfinitedFiber2023>, form: "prose")

- #cite(<cleantechgroupGlobalCleantech1002023>, form: "prose") Global cleantech 100

- #cite(<SOJODoortodoorClothing2023>, form: "prose") Alterations and repairs made easy

- #cite(<GoodYouSustainable2023>, form: "prose") Ethical brand ratings

=== Sustainable Food
<sustainable-food>
#strong[provenance and traceability of food]

- Sustainability Accounting Standards Board, part of the International Financial Reporting Standards Foundation

- Global Reporting Iniative

- #cite(<RealityLabsResearch2022>, form: "prose")

- #cite(<katiegustafsonWhyTracingSeafood2022>, form: "prose") proposes a #strong["Uniform traceability system for the entire supply chain"] for seafood

- #cite(<munozCarbonFootprintEconomic2023>, form: "prose") Is there such a thing as sustainable fishing? Bottom trawling is the worst and should be banned.

- #cite(<RealTimeESG2021>, form: "prose") "Real Time ESG Tracking From StockSnips"

- #cite(<mamedeElementalFingerprintingSea2022>, form: "prose") proposes #emph[Seafood tracing];: Fingerprinting of Sea Urchin.

- #cite(<watersEthicsChoiceAnimal2015>, form: "prose") #strong[(Need access!)]

- #cite(<cawthornControversialCuisineGlobal2016>, form: "prose") #strong[(Need access! ncku doesn’t subsribe)]

- #cite(<gamborgAttitudesRecreationalHunting2017>, form: "prose") #strong[(Need access!)]

- #cite(<neethirajanDigitalLivestockFarming2021>, form: "prose") using biometric sensors to track livestock sustainability.

- #cite(<rayWeb3ComprehensiveReview2023>, form: "prose") comprehensive overview of Web3.

- #cite(<HumanCenteredWeb32022>, form: "prose") human-centered web3

- #cite(<patelBlockchainTechnologyFood2023>, form: "prose") livestock products (meat) are 15% of agricultural foods valued at €152 billion in 2018.

- #cite(<incGlanceAlexandriaRealTime>, form: "prose")

- #cite(<timnicolleFintechLendingWhose2017>, form: "prose")

- EAT-Lancet diet

- #cite(<eshenelsonHeatWarTrade2023>, form: "prose") increased volatility in food prices

- #cite(<changAuthenticationFishSpecies2021>, form: "prose") fish fraud is a large global problem but it’s possible to use DNA-tracking to prove where the fish came from. In "2019, the 27 KURA SUSHI branches in Taiwan sold more than 46 million plates of sushi. in Taiwan"

==== Perennial Crops
<perennial-crops>
- Multi-year crops reduce inputs of gasoline, labor, etc. #cite(<aubreystreitkrugPathwaysPerennialFood2023>, form: "prose")

- Large agritech like Monsanto rely on selling seeds annualy for profits, which has lead to farmer suicides when crops fail.

==== Culture, Community, Cuisine, Storytelling
<culture-community-cuisine-storytelling>
- #cite(<tsingMushroomEndWorld2015>, form: "prose") mushrooms

Food is about enticing human imagination and taste buds.

- Potato used to be a newcomer and innovative crop in Europe, and not it’s so common, we forget it’s no originally from here.

- #cite(<aubreystreitkrugPathwaysPerennialFood2023>, form: "prose") food is also about cuisine and culture; foods become popular if we hear stories and see cuisine around a particular crop.

- "The agricultural sector contributes to approximately 13.5% of the total global anthropogenic greenhouse gas emissions and accounts for 25% of the total CO#sub[2] emission" #cite(<nabipourafrouziComprehensiveReviewCarbon2023>, form: "prose");. #cite(<pooreReducingFoodEnvironmental2018>, form: "prose") suggests 26% of carbon emissions come from food production. #cite(<FoodPrints2015>, form: "prose") reports dairy (46%) and meat and fish (29%) products making up the largest GHG emission potential. #cite(<springmannGlobalRegionalCosts2021>, form: "prose") proposes veganism is the most effective decision to reduce personal CO#sub[2] emissions.

Complex supply chains make seafood (marine Bivalvia, mollusks) logistics prone to fraud, leading to financial losses and threats to consumer health @santosCurrentTrendsTraceability2023. The same is true for cocoa beans, which are at risk from food fraud @fanningLinkingCocoaQuality2023.

- IARC warns aspartame (artificial sweetener found in many soft drinks) could cause cancer \[ADD CITATION\].

- #cite(<yapLifeCycleAssessment2023>, form: "prose") Singapore disposes of 900,000 tonnes of plastic waste out of which only 4% is recycled.
- #cite(<kiesslingWhatPotentialDoes2023>, form: "prose") Single-use plastics make up 44-68% of all waste mapped by citizen scientists.

==== Food Waste
<food-waste>
There are several initiatives to reduce food waste by helping people consume food that would otherwise be throw away.

#figure(
  align(center)[#table(
    columns: (30.56%, 34.72%, 34.72%),
    align: (auto,auto,auto,),
    table.header([Name], [Link], [],),
    table.hline(),
    [Karma], [apps.apple.com/us/app/karma-save-food-with-a-tap/id1087490062], [],
    [ResQ Club], [resq-club.com], [#cite(<kristinakostapLEVITASONAUus2022>, form: "prose") ResQ Club in Finland and Estonia for reducing food waste by offering a 50% discount on un-eaten restaurant meals before they are thrown away.],
    [Kuri], [], [#cite(<hajejankampsKuriAppThat2022>, form: "prose") Less impact of food],
    [Social media groups (no app)], [], [],
  )]
  , caption: [Food saving apps]
  , kind: table
  )

- #cite(<ROOS2023107623>, form: "prose") identified 5 perspectives in a small study (#emph[n=106];) of views on the Swedish food system:

#figure(
  align(center)[#table(
    columns: (36.11%, 63.89%),
    align: (auto,auto,),
    table.header([Perspective], [Content],),
    table.hline(),
    [#emph["The diagnostic perspective"];], [“#emph[All hands on deck to fix the climate”];],
    [#emph["The regenerative perspective"];], [“#emph[Diversity, soil health and organic agriculture to the rescue”];],
    [#emph["The fossil-free perspective"];], [“#emph[Profitable Swedish companies to rid agriculture and the food chain of fossil fuel”];],
    [#emph["The consumer-driven perspective"];], [#emph["A wish-list of healthy, high-quality and climate-friendly foods"];],
    ["The hands-on perspective"], ["Tangible solutions within the reach of consumers and the food industry"],
  )]
  , caption: [Perspective on food systems in Sweden.]
  , kind: table
  )

- "regenag", Václav Kurel, we need help consumers demand regenerative agriculture #cite(<balticseaactiongroupEITFoodRegenerative2023>, form: "prose")

- #cite(<kommendaWouldCarbonFood2022>, form: "prose") Carbon Food Labels

- Food Sovereignty: "The global food sovereignty movement, which had been building momentum since its grassroots conception in the late ’90s, quickly gained traction with its focus on the rights of people everywhere to access healthy and sustainable food. One of the pillars of the movement lies in using local food systems to reduce the distance between producers and consumers."

- #cite(<caitlinstall-paquetFreshCityRise2021>, form: "prose");: "We can grow foods just as well in the inner city as we can out in the country because we’re agnostic to arable land," says Woods. "Because we grow indoors and create our own weather, \[climate change\] doesn’t affect our produce."

- #cite(<reneesalmonsenAsiaLargestVertical2018>, form: "prose");: Vertical farm in Taoyuan

- #cite(<catherineshuSoutheastAsiaFarmtotable2023>, form: "prose");: #emph[Intensive Farming Practices vs] Farm to table

- #cite(<akshatrathiChrisSaccaReturns2021>, form: "prose") and #cite(<lowercarboncapitalLowercarbonCapital2023>, form: "prose") climate startup funding.

- Only make what is ordered.

==== Farm to Fork
<farm-to-fork>
Farm to fork is a European Union policy to shorten the supply chain from the producer to the consumer and add transparency to the system.

Supply chain innovation in agriculture.

- Farm to Fork #cite(<financialtimesSustainabilityIdeasThat2022>, form: "prose")

=== Sustainable Construction
<sustainable-construction>
- According to #cite(<debnathSocialMediaEnables2022>, form: "prose") 39% of global CO#sub[2] emissions comes from the building sector.
- Construction is large emitter because of the use of concrete; super tall buildings are very CO#sub[2] intensive @zhaoEmbodiedCarbonBased2015.
- embodied carbon
- #cite(<oikosdenktankWebinarDoughnutEconomics2021>, form: "prose") circular material procurement requires new skills. How to reuse old paint? Small projects can have large social impact.
- For example, #cite(<DURIEZ2022454>, form: "prose") shows how simply by reducing material weight it’s possible to design more sustainable transportation.

== Design Implications
<design-implications-2>
#figure(
  align(center)[#table(
    columns: (34.72%, 65.28%),
    align: (auto,auto,),
    table.header([Category], [Implication],),
    table.hline(),
    [Greenwashing], [Personal CO2 tracking is ineffective and the focus should be on systematic change towards circular design and zero waste practices.],
    [], [App shows traceability.],
    [], [Help consumers to demand more],
    [Lack of transparency], [Make open data easy to use in everyday life],
    [Transparency], [The key idea is making CO#sub[2] Visible.],
    [Greenwashing], [Rank companies based on sustainability],
    [], [Help you to decide: what to buy, how to save, where to invest.],
    [Decision Fatique], [What if there was a "Green Filter" on every product everywhere?],
    [], [Become a Sustainability-Aware App or Game.],
    [], [Focus on how college students can invest in specific industries?],
    [], [Where to shop rankings for groceries: list worst offenders in terms of products; shop and invest according to your values.],
    [], [What Quantified Self look like for sustainability?],
    [], [Empowering people to live a sustainable day],
    [], [What if there was a "Green Filter" on every product everywhere?],
    [], [Become a Sustainability-Aware App or Game.],
    [], [Guidance could help young people beat climate anxiety by taking meaningful action.],
    [], [The app is just as much about helping people deal with climate anxiety as it’s with solving the climate issue.],
    [], [List of metrics that should be tracked to enable useful analytics. Ex: % of beach pollution, air pollution, water pollution (I had this idea while meditating). In essence, "green filter" is a central data repository not unlike "Apple Health for Sustainability".],
    [], [Health and fitness category apps],
    [], [Using "green filter" you can get a personalized sustainability plan and personal coach to become healthy and nature-friendly.],
    [], [All green categories — Green hub — Ask the user to prioritize],
    [], [In my "green filter" AI advisor app’s scenario, the AI is scanning for opportunities matching the user’s sustainable investment appetite and risk profile, using different methods of analysis, including alternative data sources. Traditionally, financial analysts only looked at traditional data, such as company reports, government reports, historic performance, etc., for preparing advisory guidance to their clients. With the advent of AI and big data analysis, many other options of research data have become available, for example, accurate weather predictions for agriculture can affect guidance, because of expected future weather disasters in the area. Other examples include policy predictions, pollution metrics, etc.],
    [], [Professional financial advisors use automated tools to analyze data and present it in human form to clients. Today’s ubiquitous mobile interfaces, however, provide the opportunity to 'cut out the middleman' and provide similar information to clients directly, at a lower cost and a wider scale, often without human intervention. Additional (more expensive) "human-judgment- as-a-service", a combination of robots + human input, can help provide further personalized advice for the consumer, still at a cheaper price than a dedicated human advisor. Everyone can have a financial advisor.],
    [], [Narrative design bring together film school #strong[storytelling] experience with design.],
    [], [Rebuilt the app as a personalized, narrative lifestyle feed.],
    [], [Your shopping products mostly come from Protector and Gamble (3x) and Nestle. These are large conglomerates with a massive CO#sub[2] footprint. See the index to find some alternatives.],
    [], [How the design can connect people to sustainable outcomes while shopping and investing? Perhaps even forming a community of sustainable action. What I showed in class looks like an app but it could also be a physical object (a speculative design). From the presentations I saw most students seemed to be interested in form and light (many lamps) and a couple were about medical uses. I don’t remember seeing one that could be compatible with the environmental sustainability focus unfortunately…],
    [], [#strong[Guided Sustainability] "refers to a concept of using technology, such as AI and machine learning, to help individuals and organizations make more sustainable decisions and take actions that promote environmental and social sustainability. This can include things like analyzing data on resource usage and emissions, providing recommendations for reducing the environmental impact of operations, or helping to identify and track progress towards sustainability goals. The goal of guided sustainability is to make it easier for people to understand their impact on the environment and to take steps to reduce that impact."],
    [], [Young people are stuck inside platforms. You don’t own the data you put on TikTok. You can’t leave because you’ll lose the audience.],
    [], [With this perspective of scale, what would a shopping experience look like if one knew at the point of sale, which products are greener, and which are more environmentally polluting?],
    [], [AI Financial Advisors will need to go further to motivate users. because of the nature of the technology, which is based on the quality of the data the systems ingest, they are prone to mistakes.],
    [Generative AI], [Allow producers to make use of Speculative and Participatory design to test out new product ideas?],
  )]
  , kind: table
  )

influences UI design patterns #cite(<joyceRiseGenerativeAIdriven2024>, form: "prose")

human-centered design Explain ISO9241-210, user experience, iteration

#horizontalrule

title: A.I. sidebar\_position: 3 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

== Human Patterns Enable Computers to Become AIs
<human-patterns-enable-computers-to-become-ais>
The fact that AI systems work so well is proof that we live in a measurable world. There world is filled with structures. Nature, cultures, languages, human interactions, all form intricate patterns. Computer systems are becoming increasingly powerful in their ability copy these patterns into computer models - known as machine learning. As of 2023, 97 zettabytes (and growing) of data was created in the world per year @soundaryajayaramanHowBigBig2023. Big data is a basic requirement for training AIs, enabling learning from the structures of the world with increasing accuracy. Representations of the real world in digital models enable humans to ask questions about the real-world structures and to manipulate them to create synthetic experiments that may match the real world (if the model is accurate enough). This can be used for generating human-sounding language and realistic images, finding mechanisms for novel medicines as well as understanding the fundamental functioning of life on its deep physical and chemical level @nopriorsInceptiveCEOJakob2023.

Already ninety years ago @mccullochLogicalCalculusIdeas1943 proposed the first mathematical model of a neural network inspired by the human brain. Alan Turing’s Test for Machine Intelligence followed in 1950. Turing’s initial idea was to design a game of imitation to test human-computer interaction using text messages between a human and 2 other participants, one of which was a human, and the other - a computer. The question was, if the human was simultaneously speaking to another human and a machine, could the messages from the machine be clearly distinguished or would they resemble a human being so much, that the person asking questions would be deceived, unable to realize which one is the human and which one is the machine? @turingCOMPUTINGMACHINERYINTELLIGENCE1950.

#quote(block: true)[
Alan Turing: #emph["I believe that in about fifty years’ time it will be possible to program computers, with a storage capacity of about 10#super[9];, to make them play the imitation game so well that an average interrogator will not have more than 70 percent chance of making the right identification after five minutes of questioning. … I believe that at the end of the century the use of words and general educated opinion will have altered so much that one will be able to speak of machines thinking without expecting to be contradicted."] - from @stanfordencyclopediaofphilosophyTuringTest2021
]

By the 2010s AI models became capable enough to beat humans in games of Go and Chess, yet they did not yet pass the Turing test. AI use was limited to specific tasks. While over the years, the field of AI had seen a long process of incremental improvements, developing increasingly advanced models of decision-making, it took an #strong[#emph[increase in computing power];] and an approach called #strong[#emph[deep learning];];, a variation of #strong[#emph[machine learning (1980s),];] largely modeled after the #strong[#emph[neural networks];] of the biological (human) brain, returning to the idea of #strong[#emph[biomimicry];];, inspired by nature, building a machine to resemble the connections between neurons, but digitally, on layers much deeper than attempted before.

==== Reinforcement Learning with Human Feedback (RLHF)
<reinforcement-learning-with-human-feedback-rlhf>
Combining deep learning with reinforcement learning and reinforcement learning with human feedback (RLHF) enabled AI to achieve intelligence to beat the Turing test @karamankeChatGPTArchitectBerkeley2022@christianoMyResearchMethodology2021@christianoDeepReinforcementLearning2017. OpenAI co-founder John Schulman describes RLHF: "the models are just trained to produce a single message that gets high approval from a human reader" @karamankeChatGPTArchitectBerkeley2022.

The nature-inspired approach was successful. Innovations such as #strong[#emph[back-propagation];];for reducing errors through updating model weights and #strong[#emph[transformers];] for tracking relationships in sequential data (for example sentences), AI models became increasingly capable @vaswaniAttentionAllYou2017@merrittWhatTransformerModel2022. Generative Adversarial Networks\*\*\* (GAN), (#strong[ADD CITATION, 2016];), and #strong[#emph[Large Language Models (];ADD CITATION#emph[, 2018)];];, enabled increasingly generalized models, capable of more complex tasks, such as language generation. One of the leading scientists in this field of research, Geoffrey Hinton, had attempted back-propagation already in the 1980s and reminiscents how "the only reason neural networks didn’t work in the 1980s was because we didn’t have have enough data and we didn’t have enough computing power" @cbsmorningsFullInterviewGodfather2023.

- How do transformers work? Illustration #cite(<alammarIllustratedTransformer2018>, form: "prose")

By the 2020s, AI-based models became a mainstay in medical research, drug development, patient care @LEITE20212515@holzingerAILifeTrends2023, quickly finding potential vaccine candidates during the COVID19 pandemic @ZAFAR2022249, self-driving vehicles, including cars, delivery robots, drones in the sea and air, as well as AI-based assistants. The existence of AI models has wide implications for all human activities from personal to professional. The founder of the largest chimp-maker NVIDIA calls upon all countries do develop their own AI-models which would encode their local knowledge, culture, and language to make sure these are accurately captured @worldgovernmentssummitConversationFounderNVIDIA2024.

OpenAI has researched a wide range of approaches towards artificial general intelligence (AGI), work which has led to advances in large language models@ilyasutskeverIlyaSutskeverAI2018@aifrontiersIlyaSutskeverAI2018. In 2020 OpenAI released a LLM called GPT-3 trained on 570 GB of text @alextamkinHowLargeLanguage2021 which was adept in text-generation. @Singer2022MakeAVideoTG describes how collecting billions of images with descriptive data (for example the descriptive #emph[alt] text which accompanies images on websites) enabled researchers to train AI models such as #strong[#emph[stable diffusion];] for image-generation based on human-language. These training make use of #strong[#emph[Deep Learning];];, a layered approach to AI training, where increasing depth of the computer model captures minute details of the world. Much is still to be understood about how deep learning works; the fractal structure of deep learning can only be called mysterious @sohl-dicksteinBoundaryNeuralNetwork2024.

Hinton likes to call AI an #emph[idiot savant];: someone with exceptional aptitude yet serious mental disorder @cbsmorningsFullInterviewGodfather2023. Large AI models don’t understand the world like humans do. Their responses are predictions based on their training data and complex statistics. Indeed, the comparison may be apt, as the AI field now offers jobs for #emph[AI psychologists (ADD CITATION)];, whose role is to figure out what exactly is happening inside the 'AI brain'. Understading the insides of AI models trained of massive amounts of data is important because they are #strong[#emph[foundational];];, enabling a holistic approach to learning, combining many disciplines using languages, instead of the reductionist way we as human think because of our limitations @capinstituteGettingRealArtificial2023.

Standford "thorough account of the opportunities and risks of foundation models" @bommasaniOpportunitiesRisksFoundation2021.

Foundational AI models enable #strong[#emph[generative AIs];];, a class of AI models which are able to generate many types of #strong[#emph[tokens,];] such as text, speech, audio @sanroman2023fromdi@kreukAudioGenTextuallyGuided2022, music @copetSimpleControllableMusic2023@metaaiAudioCraftSimpleOnestop2023 and video, in any language it’s trained on. Even complex structures such 3D models and even genomes are possible to generate. Generative AI is a revolution in human-AI interaction as AI models became increasingly capable of producing human-like content which is hard to separate from actual human creations. This power comes with #strong[#emph[increased need for responsibility];];, drawing growing interest in fields like #strong[#emph[AI ethics];] and #strong[#emph[AI explainability.];] Generative has a potential for misuse, as humans are increasingly confused by what is computer-generated and what is human-created, unable to distinguish one from the other with certainty.

@nobleFifthIndustrialRevolution2022 proposes AI has reached a stage of development marking beginning of the #strong[#emph[5th industrial revolution];];, a time of collaboration between humans and AI. Widespread #strong[Internet of Things (IoT)] sensor networks that gather data analyzed by AI algorithms, integrates computing even deeper into the fabric of daily human existence. Several terms of different origin but considerable overlap describe this phenomenon, including #strong[#emph[Pervasive Computing (PC)];] @rogersFourPhasesPervasive2022 and #strong[#emph[Ubiquitous Computing];];. Similar concepts are #strong[#emph[Ambient Computing];];, which focuses more on the invisibility of technology, fading into the background, without us, humans, even noticing it, and #strong[#emph[Calm Technology];];, which highlights how technology respects humans and our limited attention spans, and doesn’t call attention to itself. In all cases, AI is integral part of our everyday life, inside everything and everywhere. Today AI is not an academic concept but a mainstream reality, affecting our daily lives everywhere, even when we don’t notice it.

=== Human-in-the-Loop (HITL)
<human-in-the-loop-hitl>
AI responses are probabilistic and need some function for ranking response quality. Achieving higher percentage or correct responses requires oversight which can come in the form of human feedback (human-in-the-loop) - or by using other AIs systems which are deemed to be already well-aligned (termed Constitutional AI by Anthropic) @baileyAIEducation2023@baiConstitutionalAIHarmlessness2022. Less powerful AIs areFor example META used LLAMA 2 for aligning LLAMA 3.

One approach to reduce the issues with AI is to introduce some function for human feedback and oversight to automated systems. Human involvement can take the form of interventions from the AI-developer themselves as well as from the end-users of the AI system.

There are many examples of combination of AI and human, also known as #emph["human-in-the-loop",] used for fields as diverse as training computer vision algorithms for self-driving cars and detection of disinformation in social media posts @wuHumanintheLoopAIEnhancing2023@bonet-joverSemiautomaticAnnotationMethodology2023.

Also known as Human-based computation or human-aided artificial intelligence @Shahaf2007TowardsAT@muhlhoffHumanaidedArtificialIntelligence2019

- Stanford Institute for Human-Centered Artificial Intelligence #cite(<gewangHumansLoopDesign2019>, form: "prose")

#figure(
  align(center)[#table(
    columns: (25%, 25%, 50%),
    align: (auto,auto,auto,),
    table.header([App], [Category], [Use Case],),
    table.hline(),
    [Welltory], [Health], [Health data analysis],
    [Wellue], [Health], [Heart arrhythmia detection],
    [QALY], [Health], [Heart arrhythmia detection],
    [Starship Robots], [Delivery], [May ask for human help when crossing a difficult road or other confusing situation],
  )]
  , caption: [Examples of human-in-the-loop apps]
  , kind: table
  )

== Responsible AI Seeks to Mitigate Generative AIs’ Known Issues
<responsible-ai-seeks-to-mitigate-generative-ais-known-issues>
Given the widespread use of AI and its increasing power of foundational models, it’s important these systems are created in a safe and responsible manner. While there have been calls to pause the development of large AI experiments @futureoflifeinstitutePauseGiantAI2023 so the world could catch up, this is unlikely to happen. There are several problems with the current generation of LLMs from OpenAI, Microsoft, Google, Nvidia, and others.

Anthropic responsible #emph[scaling policy] @AnthropicResponsibleScaling2023

METR – Model Evaluation & Threat Research incubated in the Alignment Research Center @METR2023.

@christianoMyViewsDoom2023 believes there are plenty of ways for bad outcomes (existential risk) even without extinction risk.

#figure(
  align(center)[#table(
    columns: (33.33%, 66.67%),
    align: (auto,auto,),
    [Problem], [Description],
    [Monolithicity], [LLMs are massive monolithic models requiring large amounts of computing power for training to offer #strong[#emph[multi-modal];] #strong[#emph[capabilities];] across diverse domains of knowledge, making training such models possible for very few companies. #cite(<liuPrismerVisionLanguageModel2023>, form: "prose") proposes future AI models may instead consist of a number networked domain-specific models to increase efficiency and thus become more scalable.],
    [Opaqueness], [LLMs are opaque, making it difficult to explain why a certain prediction was made by the AI model. One visible expression of this problem are #emph[#strong[hallucinations];,] the language models are able to generate text that is confident and eloquent yet entirely wrong. Jack Krawczyk, the product lead for Google’s Bard (now renamed to Gemini): "Bard and ChatGPT are large language models, not knowledge models. They are great at generating human-sounding text, they are not good at ensuring their text is fact-based. Why do we think the big first application should be Search, which at its heart is about finding true information?"],
    [Biases and Prejudices], [AI bias is well-documented and a hard problem to solve @liangGPTDetectorsAre2023. #strong[Humans don’t necessarily correct mistakes made by computers and may instead become "partners in crime"] @krugelAlgorithmsPartnersCrime2023. People are prone to bias and prejudice. It’s a part of the human psyche. Human brains are limited and actively avoid learning to save energy. These same biases are likely to appear in LLM outputs as they are trained on human-produced content. Unless there is active work to try to counter and eliminate these biases from LLM output, they will appear frequently.],
    [Missing Data], [LLMs have been pre-trained on massive amounts of public data, which gives them the ability for for reasoning and generating in a human-like way, yet they are missing specific private data, which needs to be ingested to augment LLMs ability to respond to questions on niche topics @Liu_LlamaIndex_2022.],
    [Lack of Legislation], [#cite(<anderljungFrontierAIRegulation2023>, form: "prose") OpenAI proposes we need to proactively work on common standards and legislation to ensure AI safety. It’s difficult to come up with clear legislation; the U.K. government organized the first AI safety summit in 2023 #cite(<browneBritainHostWorld2023>, form: "prose");.],
  )]
  , caption: [Table summarizing some problems with contemporary AIs.]
  , kind: table
  )

In 2024, OpenAI released its "Model Spec" to define clearly their approach to AI safety with the stated intention to provide clear guidelines for the RLHF approach. #cite(<openaiIntroducingModelSpec2024>, form: "prose")

OECD defines AI incident terms #cite(<DefiningAIIncidents2024>, form: "prose")

Foundation data-sets such as LAION-5B @romainbeaumontLAION5BNEWERA2022@schuhmannLAION5BOpenLargescale2022

Knowing Machines

=== Open Source v.s. Closed-Source AI
<open-source-v.s.-closed-source-ai>
One of the large debates in the AI industry is whether closed-sourced or open-sourced development will be lead to more AI safety.

Historically open-source has been useful for finding bugs in code as more pairs of eyes are looking at the code and someone may see a problem the programmers have not noticed. Proponents of closed-source development however worry about the dangers or releasing such powerful technology openly and the possibility of bad actors such as terrorists, hackers, violent governments using LLMs for malice.

In any case, open or closed-sourced, real-world usage of LLMs may demonstrate the limitations and edge-cases of AI. Hackathons such as #cite(<peteWeHostedEmergencychatgpthackathon2023>, form: "prose") help come up with new use-cases and disprove some potential ideas.

Red-teaming means pushing the limits of LLMs, trying to get them to produce outputs that are racist, false, or otherwise unhelpful.

#figure(
  align(center)[#table(
    columns: (24.66%, 24.66%, 26.03%, 24.66%),
    align: (auto,auto,auto,auto,),
    table.header([AI Model], [Released], [Company], [License],),
    table.hline(),
    [GPT-1], [2018], [OpenAI], [Open Source],
    [GTP-2], [2019], [OpenAI], [Open Source],
    [Turing-NLG], [2020], [Microsoft], [Proprietary],
    [GPT-3], [2020], [OpenAI], [Open Source],
    [GPT-3.5], [2022], [OpenAI], [Proprietary],
    [GPT-4], [2023], [OpenAI], [Proprietary],
    [AlexaTM], [2022], [Amazon], [Proprietary],
    [NeMo], [2022], [NVIDIA], [Open Source],
    [PaLM], [2022], [Google], [Proprietary],
    [LaMDA], [2022], [Google], [Proprietary],
    [GLaM], [2022], [Google], [Proprietary],
    [BLOOM], [2022], [Hugging Face], [Open Source],
    [Falcon], [2023], [Technology Innovation Institute], [Open Source],
    [Tongyi], [2023], [Alibaba], [Proprietary],
    [Vicuna], [2023], [Sapling], [Open Source],
    [Wu Dao 3], [2023], [BAAI], [Open Source],
    [LLAMA 2], [2023], [META], [Open Source],
    [PaLM-2], [2023], [Google], [Proprietary],
    [Claude 3], [2024], [Anthropic], [Proprietary],
    [Mistral Large], [2024], [Mistral], [Proprietary],
    [Gemini 1.5], [2024], [Google], [Proprietary],
    [LLAMA 3], [2024], [META], [Open Source],
    [GPT-5], [202?], [OpenAI], [Unknown; trademark registered],
  )]
  , caption: [Summary of 7 years of rapid AI model innovation since the first LLM was publicly made available in 2018 @brown2020language@tamkin2021@alvarezGenerateChatbotTraining2021@hinesOpenAIFilesTrademark2023@metaIntroducingMetaLlama2024.]
  , kind: table
  )

The proliferation of different models enables comparisons of performance based on several metrics from accuracy of responses to standardized tests such as GMAT usually taken my humans to reasoning about less well defined problem spaces. @chiang2024chatbot@lmsys.orgGPT4TurboHasJust2024 open-source AI-leaderboard project has collected over 500 thousand human-ranking of outputs from 82 large-language models, evaluating reasoning capabilities, which currently rate GPT-4 and Claude 3 Opus as the top-performers. @zellersHellaSwagCanMachine2019’s HellaSwag paper is also accompanied by a leaderboard website (still being updated after publication) listing AI model performance most recent entry April 16, 2024).

Metacognition – Claude 3 is the first model capable of it?, like the zero waste workshop training guidebook.

Metacognition defined as #emph[knowing about knowing] @metcalfeMetacognitionKnowingKnowing1994 or “#emph[keeping track of your own learning”] @zerowasteeuropeZeroWasteHandbook2022.

- #cite(<dwarkeshpatelMarkZuckerbergLlama2024>, form: "prose") META open-sourced the largest language model (70 billion parameters) which with performance rivaling several of the proprietary models.

- Image-generation is now fast it’s possible to create images in real-time while the user is typing #cite(<dwarkeshpatelMarkZuckerbergLlama2024>, form: "prose")

- Measuring Massive Multitask Language Understanding (MMLU) #cite(<hendrycksMeasuringMassiveMultitask2020>, form: "prose");.

== What Role Should The AI Take?
<what-role-should-the-ai-take>
Literature delves into human-AI interactions on almost human-like level discussing what kind of roles can the AIs take. @seeberMachinesTeammatesResearch2020 proposes a future research agenda for regarding #strong[#emph[AI assistants as teammates];] rather than just tools and the implications of such mindset shift.

From Assistance to Collaboration

It’s not only what role the AI takes but how that affects the human. As humans have ample experience relating to other humans and as such the approach towards an assistants vs a teammate will vary. One researcher in this field #cite(<karpusAlgorithmExploitationHumans2021>, form: "prose") is concerned with humans treating AI badly and coins the term #strong[“#emph[algorithm exploitation”];];#emph[.]

- From assistant -\> teammate -\> companion -\> friend The best help for anxiety is a friend. AIs are able to assume different roles based on user requirements and usage context. This makes AI-generated content flexible and malleable.

Just as humans, AIs are continuously learning. #cite(<ramchurnTrustworthyHumanAIPartnerships2021>, form: "prose") discusses positive feedback loops in continually learning AI systems which adapt to human needs.

=== Context of Use
<context-of-use>
Where is the AI used?

#cite(<schoonderwoerdHumancenteredXAIDeveloping2021>, form: "prose") focuses on human-centered design of AI-apps and multi-modal information display. It’s important to understand the domain where the AI is deployed in order to develop explanations. However, in the real world, how feasible is it to have control over the domain? #cite(<calistoIntroductionHumancentricAI2021>, form: "prose") discusses #strong[multi-modal AI-assistant] for breast cancer classification.

=== Generative AIs Enable New UI Interactions
<generative-ais-enable-new-ui-interactions>
The advances in the capabilities of LLMs makes it possible to achieve #strong[#emph[user experience (UX) which previously was science fiction];];.

- Towards Useful Personal Assistants

The history of #emph[intelligent interfaces] is long @kobetzDecodingFutureEvolution2023

There’s wide literature available describing human-AI interactions across varied scientific disciplines. While the fields of application are diverse, some key lessons can be transferred horizontally across fields of knowledge.

#figure(
  align(center)[#table(
    columns: (34.25%, 65.75%),
    align: (auto,auto,),
    table.header([Field of Usage], [Description],),
    table.hline(),
    [Shipping], [#cite(<veitchSystematicReviewHumanAI2022>, form: "prose") highlights the active role of humans in Human-AI interaction is autonomous self-navigating ship systems.],
    [Data Summarizaton], [AI is great at summarizing and analyzing data @petersGoogleChromeWill2023@tuWhatShouldData2023],
    [Childcare], [Generate personalized bedtime stories],
    [Design Tools], [#cite(<DavidHoangHow2024>, form: "prose");],
  )]
  , caption: [A very small illustration of generative AI usage across disparate fields of human life.]
  , kind: table
  )

- #cite(<cromptonDecisionpointdilemmaAnotherProblem2021>, form: "prose") highlights AI as decision-support for humans while differentiating between #strong[#emph[intended];] and #strong[#emph[unintended];] influence on human decisions.
- #cite(<chengInvestigationTrustAIenabled2022>, form: "prose") describes AI-based support systems for collaboration and team-work.
- #strong[Effective Accelerationism (often shortened to E\\acc) boils down to the idea that “];the potential for negative outcomes shouldn’t deter rapid advancement”

=== Multi-modality
<multi-modality>
By early 2024, widely available LLMs front-ends such as Gemini, Claude and ChatGPT have all released basic features for multi-modal communication. In practice, this means combination several AI models within the same interface. For example, on the input side, one model is used for human speech or image recognition which are transcribed into tokens that can be ingested into an LLM. On the output side, the LLM can generate instructions which are fed into an image / audio generation model or even computer code which can be ran on a virtual machine and then the output displayed inside the conversation.

The quality of LLM output depends on the quality of the provided prompt. #cite(<zhouLargeLanguageModels2022>, form: "prose") reports creating an "Automatic Prompt Engineer" which automatically generates instructions that outperform the baseline output quality by using another model in the AI pipeline in front of the LLM to enhance the human input with language that is known to produce better quality. This approach however is a moving target as foundational models keep changing rapidly and the baseline might differ from today to 6 months later.

Multimodal model development is also ongoing. In the case of Google’s Gemini 1.5 Pro, one model is able to handle several types of prompts from text to images. Multimodal prompting however requires larger context windows, as of writing, limited to 1 million tokens in a private version allows combining text and images in the question directed to the AI, used to reason in examples such as a 44-minute Buster Keaton silent film or Apollo 11 launch transcript (404 pages) #cite(<googleMultimodalPrompting44minute2024>, form: "prose");.

=== Conversational AI
<conversational-ai>
- #cite(<baileyAIEducation2023>, form: "prose") believes people are used to search engines and it will take a little bit time to get familiar with talking to a computer in natural language. NVIDIA founder Jensen Huang makes the idea exceedingly clear, saying #emph["Everyone is a programmer. Now, you just have to say something to the computer"] #cite(<leswingNvidiaRevealsNew2023>, form: "prose");.

There are noticeable differences in the quality of the LLM output, which increases with model size. #cite(<levesqueWinograd2012>, form: "prose") developed the #emph[Winograd Schema Challenge];, looking to improve on the Turing test, by requiring the AI to display an understanding of language and context. The test consists of a story and a question, which has a different meaning as the context changes: "The trophy would not fit in the brown suitcase because it was too big" - what does the #emph[it] refer to? Humans are able to understand this from context while a computer models would fail. Even GPT-3 still failed the test, but later LLMs have been able to solve this test correctly (90% accuracy) #cite(<kocijanDefeatWinogradSchema2022>, form: "prose");. This is to say AI is in constant development and improving it’s ability to make sense of language.

#strong[#emph[ChatGPT];] is the first #strong[#emph[user interface (UI)];] built on top of GPT-4 by OpenAI and is able to communicate in a human-like way - using first-person, making coherent sentences that sound plausible, and even - confident and convincing. #cite(<wangEconomicCaseGenerative2023>, form: "prose") ChatGPT reached 1 million users in 5 days and 6 months after launch has 230 million monthly active users. While it was the first, competing offers from Google (Gemini), Anthrophic (Claude), Meta (Llama) and others quickly followed starting a race for best performance across specific tasks including standardized tests from math to science to general knowledge and reasoning abilities.

OpenAI provides AI-as-a-service through its #strong[#emph[application programming interfaces (APIs),];] allowing 3rd party developers to build custom UIs to serve the specific needs of their customer. For example Snapchat has created a #strong[#emph[virtual friend];] called "My AI" who lives inside the chat section of the Snapchat app and helps people write faster with predictive text completion and answering questions. The APIs make state-of-the-art AI models easy to use without needing much technical knowledge. Teams at AI-hackathons have produced interfaces for problems as diverse as humanitarian crises communication, briefing generation, code-completion, and many others. For instance, @unleashSebastianAi2017 used BJ Fogg’s #strong[#emph[tiny habits model];] to develop a sustainability-focused AI assistant at the Danish hackathon series Unleash, to encourage behavioral changes towards maintaining an aspirational lifestyle, nudged by a chatbot buddy.

ChatGPT makes it possible to #strong[#emph[evaluate AI models];] just by talking, i.e.~having conversations with the machine and judging the output with some sort of structured content analysis tools. #cite(<oconnorOpenArtificialIntelligence2023>, form: "prose") and #cite(<cahanConversationChatGPTRole2023>, form: "prose") have conversations about science with AI. #cite(<pavlikCollaboratingChatGPTConsidering2023>, form: "prose") and #cite(<brenta.andersWhyChatGPTSuch2022>, form: "prose") report on AI in education. #cite(<kechtQuantifyingChatbotsAbility2023>, form: "prose") suggests AI is even capable of learning business processes.

- #cite(<fuLearningConversationalAI2022>, form: "prose") Learning towards conversational AI: Survey

=== Affective Computing and AI UX
<affective-computing-and-ai-ux>
Rosalind Picard is the founder of the #strong[#emph[affective computing];] field. Her pioneering work aims to make computers more human-friendly. Because of the conversational nature of LLMs, they are very useful for affective computing, an approach to recognizing human emotions with machines and providing users experiences that take human emotion into account #cite(<picardAffectiveComputing1997>, form: "prose");.

Just as LLMs, affective computing relies on input data. It’s not an overstatement to say data from all the processes around us will define the future of computing as #cite(<hiittvWojciechSzpankowskiEmerging2021>, form: "prose") puts it. In the early examples, electrodermal activity of the skin and heart-rate variance data were used to detect the emotional state and stress level of the user @zangronizElectrodermalActivitySensor2017@velmovitskyUsingAppleWatch2022. This technology has since become mainstream in products such as Fitbit and the Apple Watch among many others.

Affective Design emerged from affective computing with a focus on understanding user emotions to design UI/UX to which elicits specific emotional responses @Reynolds2001DesigningFA.

Apple Watch features Fall Detection which I’ve experienced personally. Riding my bicycle to the NCKU library I slipped and landed on my stomach on the pavement. Watch immediately asked me: "It looks like you’ve taken a hard fall" and offered an option to call the ambulance. Fortunately I was OK but if I did need assistance, this AI algorithm delivered contextual help which could save my health.

On the output side, #cite(<lvCutenessIrresistibleImpact2022>, form: "prose") studies the effect of #strong[#emph[cuteness];] of AI apps on users and found high perceived cuteness correlated with higher willingness to use the apps, especially for emotional tasks.

- #cite(<liuMachineGazeOnline2021>, form: "prose") meanwhile suggests higher #strong[#emph[algorithmic transparency may inhibit anthropomorphism.];] People are less likely to attribute humanness to the AI if they understand how the system works.
- #cite(<tedxTechEmotionsRoz2011>, form: "prose")
- #cite(<lexfridmanRosalindPicardAffective2019>, form: "prose")
- #cite(<hiittvRosalindPicardAdventures2021>, form: "prose")
- #cite(<bwhcnocRosalindPicard4th2023>, form: "prose")
- #cite(<singularityuniversityEngineeringEmotionAI2023>, form: "prose")

Since the first mainframe computers with rudimentary computers able to respond with text messages, humans have been drawn to discussing their private lives with a machine that doesn’t judge you like a human could. A famous anecdote is about the lab assistant of the Joseph Weizenbaum MIT ELIZA project in the mid-1960s (1996), who would dedicate extended time to talking to the machine in private. The machine was called DOCTOR and emulated a Rogerian psychotherapist, person-centered therapy developed by Carl Rogers, from the core idea that positive psychological functioning is a inherently human motivation @bassettComputationalTherapeuticExploring2019@rogersWayBeing1995.

- ELIZA is an early examples of a language model

Natural language generation exists since Eliza

Today’s machines are much more capable so it’s not a surprise humans would like to talk to them. One example is #strong[#emph[AI Friend];] is Replika, a computer model trained to be your companion in daily life. @jiangChatbotEmergencyExist2022 describes how Replika users in China using in 5 main ways, all of which rely on empathy.

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    table.header([How humans express empathy towards the Replika AI companion],),
    table.hline(),
    [Companion buddy],
    [Responsive diary],
    [Emotion-handling program],
    [Electronic pet],
    [Tool for venting],
  )]
  , caption: [Replika AI users approach to interacting with the AI friend from #cite(<jiangChatbotEmergencyExist2022>, form: "prose");.]
  , kind: table
  )

- Google is developing an AI assistant for giving life advice #cite(<goswamiGoogleReportedlyBuilding2023>, form: "prose");.
- GPT-4 is able to solve difficult task in chemistry with natural-language instructions #cite(<whiteFutureChemistryLanguage2023>, form: "prose")
- Emojis are a part of natural language #cite(<tayWhyScienceNeeds2023>, form: "prose")

=== Algorithmic Experience
<algorithmic-experience>
As a user of social media, one may be accustomed to interacting with the feed algorithms that provide a personalized #strong[#emph[algorithmic experience];];. Algorithms are more deterministic than AI, meaning they produce predictable output than AI models. Nonetheless, there are many reports about effects these algorithms have on human psychology #strong[(ADD CITATION)];. Design is increasingly relevant to algorithms, and more specifically to algorithms that affect user experience and user interfaces. #strong[#emph[When the design is concerned with the ethical, environmental, socioeconomic, resource-saving, and participatory aspects of human-machine interactions and aims to affect technology in a more human direction, it can hope to create an experience designed for sustainability.];]

#cite(<lorenzoDaisyGinsbergImagines2015>, form: "prose") underlines the role of design beyond #emph[designing] as a tool for envisioning; in her words, #emph["design can set agendas and not necessarily be in service, but be used to find ways to explore our world and how we want it to be"];. Practitioners of Participatory Design (PD) have for decades advocated for designers to become more activist through #strong[#emph[action research];];. This means to influencing outcomes, not only being a passive observer of phenomena as a researcher, or only focusing on usability as a designer, without taking into account the wider context.

#cite(<shenoiParticipatoryDesignFuture2018>, form: "prose") argues inviting domain expertise into the discussion while having a sustainable design process enables designers to design for experiences where they are not a domain expert; this applies to highly technical fields, such as medicine, education, governance, and in our case here - finance and sustainability -, while building respectful dialogue through participatory design. After many years of political outcry (ADD CITATION), social media platforms such Facebook and Twitter have begun to shed more light on how these algorithms work, in some cases releasing the source code (#cite(<nickcleggHowAIInfluences2023>, form: "prose");; #cite(<twitterTwitterRecommendationAlgorithm2023>, form: "prose");).

AI systems may make use of several algorithms within one larger model. It follows that AI Explainability requires #emph[#strong[Algorithmic Transparency];.]

The content on the platform can be more important than the interface. Applications with a similar UI depend on the community as well as the content and how the content is shown to the user.

=== Guidelines
<guidelines>
Microsoft Co-Founder predicted in 1982 #emph["personal agents that help us get a variety of tasks"] @billgatesBillGatesNext1982 and it was Microsoft that introduced the first widely available personal assistant in 1996, called Clippy, inside the Microsoft Word software. Clippy was among the first assistants to reach mainstream adoption, helping users not yet accustomed to working on a computer, to get their bearings @tashkeunemanWeLoveHate2022. Nonetheless, it was in many ways useless and intrusive, suggesting there was still little knowledge about UX and human-centered design. Gates never wavered though and is quoted in 2004 saying #emph["If you invent a breakthrough in artificial intelligence, so machines can learn, that is worth 10 Microsofts"] #cite(<lohrMicrosoftDwindlingInterest2004>, form: "prose");.

Gates updated his ideas in 2023: https:\/\/www.gatesnotes.com/AI-agents

As late as in 2017, scientists were trying to create a program with enough #emph[natural-language understanding] to extract basic facts from scientific papers #cite(<stocktonIfAICan2017>, form: "prose")

Might we try again?

With the advent of ChatGPT, the story of Clippy has new relevance as part of the history of AI Assistants. #cite(<benjamincassidyTwistedLifeClippy2022>, form: "prose") and #cite(<abigailcainLifeDeathMicrosoft2017>, form: "prose") illustrate beautifully the story of Clippy and #cite(<tashkeunemanWeLoveHate2022>, form: "prose") ask poignantly: "We love to hate Clippy — but what if Clippy was right?"

- Life-like speaking faces from Microsoft Research turn a single image and voice clip into a life-like representation @xuVASA1LifelikeAudioDriven2024.

Many researchers have discussed the user experience (UX) of AI to provide #strong[#emph[usability guidelines];];.

Microsoft provides guidelines for Human-AI interaction (#cite(<li2022assessing>, form: "prose");; #cite(<amershiGuidelinesHumanAIInteraction2019>, form: "prose");) which provides useful heuristics categorized by context and time.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Context], [Time],),
    table.hline(),
    [Initially], [],
    [During interaction], [],
    [When wrong], [],
    [Over time], [],
  )]
  , caption: [Microsoft’s heuristics categorized by context and time.]
  , kind: table
  )

#cite(<combiManifestoExplainabilityArtificial2022>, form: "prose") proposes a conceptual framework for XAI, analysis AI based on Interpretability, Understandability, Usability, and Usefulness.

- #cite(<zimmermanUXDesignersPushing2021>, form: "prose") "UX designers pushing AI in the enterprise: a case for adaptive UIs"

- #cite(<WhyUXShould2021>, form: "prose") "Why UX should guide AI"

- #cite(<simonsterneUnlockingPowerDesign2023>, form: "prose") UX is about helping the user make decisions

- #cite(<davidpasztorAIUXPrinciples2018>, form: "prose")

- #cite(<andersonWaysArtificialIntelligence2020>, form: "prose")

- #cite(<lennartziburskiUXAI2018>, form: "prose") UX of AI

- #cite(<stephaniedonaholeHowArtificialIntelligence2021>, form: "prose")

- #cite(<lexowDesigningAIUX2021>, form: "prose")

- #cite(<davidpasztorAIUXPrinciples2018>, form: "prose") AI UX principles

- #cite(<bubeckSparksArtificialGeneral2023>, form: "prose") finds ChatGPT passes many exams meant for humans.

- #cite(<suenBuildingTrustAutomatic2023>, form: "prose") discusses AI systems used for evaluating candidates at job interviews

- #cite(<wangSyntheticNeuroscoreUsingNeuroAI2020>, form: "prose") propose Neuroscore to reflect perception of images.

- #cite(<suArtificialIntelligenceEarly2022>, form: "prose") and #cite(<suArtificialIntelligenceAI2023>, form: "prose") review papers on AI literacy in early childhood education and finds a lack of guidelines and teacher expertise.

- #cite(<yangArtificialIntelligenceEducation2022>, form: "prose") proposes a curriculum for in-context teaching of AI for kids.

- #cite(<ericschmidtUXAdvancedMethod2022>, form: "prose") audiobook

- #cite(<akshaykoreDesigningHumanCentricAI2022>, form: "prose") Designing Human-Centric AI Experiences: Applied UX Design for Artificial Intelligence

- #cite(<StudiesConversationalUX2018>, form: "prose") chatbot book

- #cite(<tomhathawayChattingHumansUser2021>, form: "prose") chatbot book

- #cite(<lewAIUXWhy2020>, form: "prose") AI UX book

- AI IXD is about human-centered seamless design

- Storytelling

- Human-computer interaction (HCI) has a long storied history since the early days of computing when getting a copy machine to work required specialized skill. Xerox Sparc lab focused on early human factors work and inspired a the field of HCI to make computer more human-friendly.

- #cite(<soleimani10UIPatterns2018>, form: "prose");: UI patterns for AI, new Section for Thesis background: "Human-Friendly UX For AI"?

- #strong[Discuss what is UX for AI (per prof Liou’s comment), so it’s clear this is about UX for AI]

- What is Personalized AI?

- Many large corporations have released guidelines for Human-AI interaction. #cite(<mikaelerikssonbjorlingUXDesignAI>, form: "prose") Ericcson AI UX.

- Google’s AI Principles and provides Google’s UX for AI library @joshlovejoyUXAI@googleOurPrinciplesGoogle. In #cite(<designportlandHumansHaveFinal2018>, form: "prose");, Lovejoy, lead UX designer at Google’s people-centric AI systems department (PAIR), reminds us that while AI offers need tools, user experience design needs to remain human-centered. While AI can find patterns and offer suggestions, humans should always have the final say.

- #cite(<harvardadvancedleadershipinitiativeHumanAIInteractionArtificial2021>, form: "prose")

- #cite(<videolectureschannelCommunicationHumanAIInteraction2022>, form: "prose") "Communication in Human-AI Interaction"

- #cite(<haiyizhuHumanAIInteractionFall2021>, form: "prose")

- #cite(<akataResearchAgendaHybrid2020>, form: "prose")

- #cite(<dignumAIPeoplePlaces2021>, form: "prose")

- #cite(<boleizhouCVPR22Tutorial2022>, form: "prose")

- #cite(<readyaiHumanAIInteractionHow2020>, form: "prose")

- #cite(<vinuesaRoleArtificialIntelligence2020>, form: "prose")

- #cite(<orozcoBudapestBicycleNetwork2020>, form: "prose")

=== AI UX Design
<ai-ux-design>
- Privacy UX #cite(<jarovskyYouAreProbably2022>, form: "prose")

- AI UX dark patterns #cite(<jarovskyDarkPatternsAI2022>, form: "prose")

- AI is usually a model that spits out a number between 0 and 1, a probability score or prediction. UX is what we do with this number.

- #cite(<baileyAIEducation2023>, form: "prose") believes people will increasingly use AI capabilities through UIs that are specific to a task rather than generalist interfaces like ChatGPT.

How do the tenets of user experience (UX) apply to AI?

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    table.header([UX],),
    table.hline(),
    [Useful],
    [Valuable],
    [Usable],
    [Acessible],
    [Findable],
    [Desirable],
    [Credible],
  )]
  , kind: table
  )

#cite(<guptaDesigningAIChatbot2023>, form: "prose") proposes 3 simple goals for AI:

#figure(
  align(center)[#table(
    columns: (27.78%, 26.39%, 45.83%),
    align: (auto,auto,auto,),
    table.header([1], [2], [3],),
    table.hline(),
    [Reduce the time to task], [Make the task easier], [Personalize the experience for an individual],
  )]
  , kind: table
  )

=== Explainable AI
<explainable-ai>
The problems of opaqueness creates the field of explainable AI.

"As humans we tend to fear what we don’t understand" is a common sentiment which has been confirmed psychology @allportNaturePrejudice1979. Current AI-models are opaque ’#emph[black boxes’];, where it’s difficult to pin-point exactly why a certain decision was made or how a certain expression was reached, not unlike inside the human brain. This line of thought leads me to the idea of #strong[#emph[AI psychologists,];] who might figure out the #strong[#emph[thought patterns];] inside the model. Research in AI-explainability (XAI in literature) is on the lookout for ways to create more #strong[#emph[transparency and credibility];] in AI systems, which could lead to building trust in AI systems and would form the foundations for #strong[#emph[AI acceptance];];.

- #cite(<tristangreeneConfusedReplikaAI2022>, form: "prose");: when the quality of AI responses becomes good enough, people begin to get confused.

#cite(<bowmanEightThingsKnow2023>, form: "prose") says steering Large Language Models is unreliable; even experts don’t fully understand the inner workings of the models. Work towards improving both #strong[#emph[AI steerability];] and #strong[#emph[AI alignment];] (doing what humans expect) is ongoing. #cite(<liangHolisticEvaluationLanguage2022>, form: "prose") believes there’s early evidence it’s possible to assess the quality of LLM output transparently. #cite(<CABITZA2023118888>, form: "prose") proposes a framework for quality criteria and explainability of AI-expressions. #cite(<khosraviExplainableArtificialIntelligence2022>, form: "prose") proposes a framework for AI explainability, focused squarely on education. #cite(<holzingerMultimodalCausabilityGraph2021>, form: "prose") highlights possible approaches to implementing transparency and explainability in AI models. While AI outperforms humans on many tasks, humans are experts in multi-modal thinking, bridging diverse fields.

- Bigger models aren’t necessarily better; rather models need human feedback to improve the quality of responses #cite(<ouyangTrainingLanguageModels2022>, form: "prose")

- The user experience (UX) of AI is a topic under active development by all the largest online platforms. The general public is familiar with the most famous AI helpers, ChatGPT, Apple’s Siri, Amazon’s Alexa, Microsoft’s Cortana, Google’s Assistant, Alibaba’s Genie, Xiaomi’s Xiao Ai, and many others. For general, everyday tasks, such as asking factual questions, controlling home devices, playing media, making orders, and navigating the smart city.

The AI Credibility Heuristic: A Systematic Model explains how… similar to Daniel Kahneman’s book "Thinking, Fast and Slow".

- #cite(<slackAturaProcess2021>, form: "prose")

- #cite(<shinHowUsersInteract2020>, form: "prose");: "user experience and usability of algorithms by focusing on users’ cognitive process to understand how qualities/features are received and transformed into experiences and interaction"

- #cite(<zerilliHowTransparencyModulates2022>, form: "prose") focuses on human factors and ergonomics and argues that transparency should be task-specific.

- #cite(<holbrookHumanCenteredMachineLearning2018>, form: "prose");: To reduce errors which only humans can detect, and provide a way to stop automation from going in the wrong direction, it’s important to focus on making users feel in control of the technology.

- #cite(<ZHANG2023107536>, form: "prose") found humans are more likely to trust an AI teammate if they are not deceived by it’s identity. It’s better for collaboration to make it clear, one is talking to a machine. One step towards trust is the explainability of AI-systems.

Personal AI Assistants to date have we created by large tech companies. #strong[Open-Source AI-models open up the avenue for smaller companies and even individuals for creating many new AI-assistants.]

- An explosion of personal AI assistants powered by GPT models.
- https:\/\/socratic.org/
- https:\/\/www.youper.ai/
- https:\/\/app.fireflies.ai/login
- Murf

=== AI Acceptance
<ai-acceptance>
AI acceptance is incumbent on traits that are increasingly human-like and would make a human be acceptable: credibility, trustworthiness, reliability, dependability, integrity, character, etc.

RQ: Does AI acceptance increase with Affective Computing?

=== AI in Medicine
<ai-in-medicine>
AI has been in medicine since early days with the promise to improve health outcomes.

#strong[AI is being use in high–Stakes Situations (Medical, Cars, Etc).]

AI-based systems are being implemented in medicine, where stakes are high raising the need for ethical considerations. Since CADUCEUS in the 1970s @kanzaAIScientificDiscovery2021, the first automated medical decision making system, medical AI now provides Health Diagnosic Symptoms and AI-assistants in medical imaging. @calistoBreastScreeningAIEvaluatingMedical2022 focuses on AI-human interactions in medical workflows and underscores the importance of output explainability. Medical professionals who were given AI results with an explanation trusted the results more. @leeAIRevolutionMedicine2023 imagines an AI revolution in medicine using GPT models, providing improved tools for decreasing the time and money spent on administrative paperwork while providing a support system for analyzing medical data.

- Example of ChatGPT explaining medical terminology in a blood report.

- #cite(<singhalExpertLevelMedicalQuestion2023>, form: "prose") medial AI reaching expert-level question-answering ability.

- #cite(<ayersComparingPhysicianArtificial2023>, form: "prose") in an online text-based setting, patients rated answers from the AI better, and more empathetic, than answers from human doctors.

- #cite(<daisywolfWhereWillAI2023>, form: "prose") criticizes US healthcare’s slow adoption of technology and predicts AI will help healthcare leapfrog into a new era of productivity by acting more like a human assistant.

- #cite(<elizastricklandDrChatGPTWill2023>, form: "prose") Chat interface for medical communication

- #cite(<jeblickChatGPTMakesMedicine2022>, form: "prose") suggest complicated radiology reports can be explained to patients using AI chatbots.

- #cite(<HealthPoweredAda>, form: "prose") health app, "Know and track your symptoms"

- #cite(<BuoyHealthCheck>, form: "prose") AI symptom checker,

- #cite(<womeninaiHowCanAI>, form: "prose") AI-based health monitoring

- #cite(<HomeLarkHealth>, form: "prose") track chronic condition with AI-chat

- #cite(<stephaniedonaholeHowArtificialIntelligence2021>, form: "prose") AI impact on UX design

- #cite(<yuanSocialAnxietyModerator2022>, form: "prose");: "AI assistant advantages are important factors affecting the #emph[utilitarian/hedonic] value perceived by users, which further influence user willingness to accept AI assistants. The relationships between AI assistant advantages and utilitarian and hedonic value are affected differently by social anxiety."

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Name], [Features],),
    table.hline(),
    [Charisma], [],
    [Replika], [Avatar, Emotion, Video Call, Audio],
    [Siri], [Audio],
  )]
  , kind: table
  )

=== How Does AI Affect Human-Computer Interactions?
<how-does-ai-affect-human-computer-interactions>
The field of Human Factors and Ergonomics (HFE) emphasizes designing user experiences (UX) that cater to human needs @theinternationalergonomicsassociationHumanFactorsErgonomics2019. Designers think through every interaction of the user with a system and consider a set of metrics at each point of interaction including the user’s context of use and emotional needs.

Software designers, unlike industrial designers, can’t physically alter the ergonomics of a device, which should be optimized for human well-being to begin with and form a cohesive experience together with the software. However, software designers can significantly reduce mental strain by crafting easy-to-use software and user-friendly user journeys. Software interaction design goes beyond the form-factor and accounts for human needs by using responsive design on the screen, aural feedback cues in sound design, and even more crucially, by showing the relevant content at the right time, making a profound difference to the experience, keeping the user engaged and returning for more. In the words of @babichInteractionDesignVs2019, #strong[#emph[“\[T\*\*\*\]];];he moment of interaction is just a part of the journey that a user goes through when they interact with a product. User experience design accounts for all user-facing aspects of a product or system”.\*\*\*

Drawing a parallel from narrative studies terminology, we can view user interaction as a heroic journey of the user to achieve their goals, by navigating through the interface until a success state - or facing failure. Storytelling has its part in interface design however designing for transparency is just as important, when we’re dealing with the user’s finances and sustainability data, which need to be communicated clearly and accurately, to build long-term trust in the service. For a sustainable investment service, getting to a state of success - or failure - may take years, and even longer. Given such long timeframes, how can the app provide support to the user’s emotional and practical needs throughout the journey?

@tubikstudioUXDesignGlossary2018 argues #strong[#emph[affordance];] measures the clarity of the interface to take action in user experience design, rooted in human visual perception, however, affected by knowledge of the world around us. A famous example is the door handle - by way of acculturation, most of us would immediately know how to use it - however, would that be the case for someone who saw a door handle for the first time? A similar situation is happening to the people born today. Think of all the technologies they have not seen before - what will be the interface they feel the most comfortable with?

For the vast majority of this study’s target audience (college students), social media can be assumed as the primary interface through which they experience daily life. The widespread availability of mobile devices, cheap internet access, and AI-based optimizations for user retention, implemented by social media companies, means this is the baseline for young adult users’ expectations (as of writing in 2020).

@shinUserExperienceWhat2020 proposes the model (fig.~10) of Algorithmic Experience (AX) #strong[#emph["investigating the nature and processes through which users perceive and actualize the potential for algorithmic affordance"];] highlighting how interaction design is increasingly becoming dependent on AI. The user interface might remain the same in terms of architecture, but the content is improved, based on personalization and understanding the user at a deeper level.

In 2020 (when I proposed this thesis topic), Google had recently launched an improved natural language engine to better understand search queries @UnderstandingSearchesBetter2019, which was considered the next step towards #strong[#emph[understanding];] human language semantics. The trend was clear, and different types of algorithms were already involved in many types of interaction design, however, we were in the early stages of this technology (and still are #emph[early] in 2024). Today’s ChatGPT, Claude and Gemini have no problem understanding human semantics - yet are they intelligent?

Intelligence may be besides the point as long as AI #strong[#emph[becomes very good at reasoning];];. AI is a #strong[#emph[reasoning engine];] @shipperGPT4ReasoningEngine2023@bubeckSparksArtificialGeneral2023@baileyAIEducation2023[ for a summary];. That general observation applies to voice recognition, voice generation, natural language parsing, among others. Large consumer companies like McDonald’s are in the process of replacing human staff with AI assistants in the drive-through, which can do a better job in providing a personal service than human clerks, for whom it would be impossible to remember the information of thousands of clients. In @barrettMcDonaldAcquiresMachineLearning2019, in the words of #emph[Easterbrook];, a previous CEO of McDonald’s #emph[“#strong[How do you transition from mass marketing to mass personalization?“];];.

What are the next features that could improve the UX/UI of AI-based assistants?

- GPT 4o combines different abilities into the same model, preserving more information: https:\/\/openai.com/index/hello-gpt-4o/

@skipperHowAIChanging2022 sketches a vision of #emph["\[AI\] blend into our lives in a form of apps and services"] deeply ingrained into daily human activity.

Should AIs look anthropomorphic or fade in the background? It’s an open question. Perhaps we can expect a mix of both depending on the context of use and goals of the particular AI.

#figure(
  align(center)[#table(
    columns: (34.72%, 65.28%),
    align: (auto,auto,),
    table.header([Anthropomorphic AI User Interfaces], [Non-Anthropomorphic AI User Interfaces],),
    table.hline(),
    [AI wife @MyWifeDead2023], [Generative AI has enabled developers to create AI tools for several industries, including AI-driven website builders @constandseHowAIdrivenWebsite2018],
    [@sarahperezCharacterAIA16zbacked2023 character AI], [AI tools for web designers @patrizia-slongoAIpoweredToolsWeb2020],
    [mourning 'dead' AI @phoebearslanagic-wakefieldReplikaUsersMourn], [Microsoft Designer allows generating UIs just based on a text prompt @microsoftMicrosoftDesignerStunning2023],
    [AI for therapy @broderickPeopleAreUsing2023], [personalized bed-time stories for kids generated by AI @bedtimestory.aiAIPoweredStory2023],
    [Mental health uses: AI for bullying @sungParentsWorryTeens2023], [],
  )]
  , caption: [Some notable examples of anthropomorphic AIs for human emotions.]
  , kind: table
  )

- @costaInteractionDesignAI2022 "Interaction Design for AI Systems"

=== Human Augmentation
<human-augmentation>
Technology for augmenting human skills or replacing skills that were lost due to an accident is one usage of tech.

- @dotgoDotGo2023 makes the camera the interaction device for people with vision impairment.

=== AI-Assisted Design
<ai-assisted-design>
#strong[Tool vs Assistant? (Tools are mostly non-anthropomorphic?)]

Tools do not call attention to themselves. They don’t necessarily rely on human-like representations that call attention to themselves but rather are available in-context to help streamline specific tasks.

- #cite(<september162020WhatAIassistedDesign2020>, form: "prose") "What is AI-assisted Design?"
- #cite(<clipdropCreateStunningVisuals>, form: "prose") AI Design Assistants
- #cite(<architechturesWhatArtificialIntelligence2020>, form: "prose") Architecture with the help of AI
- #cite(<zakariyaStopUsingJasper2022>, form: "prose") Canva image generator
- #cite(<kore.aiHomepage2023>, form: "prose") Kore.ai developing custom AI-chatbots for business usage.
- #cite(<CharismaStorytellingPowered>, form: "prose") storytelling by AI

=== AI Assistants in Media Portrayals (Mostly anthropomorphic to be able to film)
<ai-assistants-in-media-portrayals-mostly-anthropomorphic-to-be-able-to-film>
How AIs are represented in popular media shapes the way we think about AIs. Some stories have AIs both in positive and negative roles, such as Star Trek and Knight Rider. In some cases like Her and Ex Machina, the characters may be complex and ambivalent rather than fitting into a simple positive or negative box. In Isaac Asimov’s books, the AIs (mostly in robot form) struggle with the 3 laws of robotics, raising thought-provoking questions.

There have been dozens of AI-characters in the movies, TV-series, games, and (comic) books. In most cases, they have a physical presence or a voice, so they could be visible for the viewers. Some include KITT (Knight Industries Two Thousand).

#figure(
  align(center)[#table(
    columns: (20%, 20%, 20%, 20%, 20%),
    align: (auto,auto,auto,auto,auto,),
    table.header([Movie / Series / Game / Book], [Character], [Positive], [Ambivalent], [Negative],),
    table.hline(),
    [2001: A Space Odyssey], [HAL 9000], [], [], [X],
    [Her], [Samantha], [X], [], [],
    [Alien], [MU/TH/UR 6000 (Mother)], [X], [], [],
    [Terminator], [Skynet], [], [], [X],
    [Summer Wars], [Love Machine], [], [], [X],
    [Marvel Cinematic Universe], [Jarvis, Friday], [X], [], [],
    [Knight Rider], [KITT], [X], [], [],
    [], [CARR], [], [], [X],
    [Star Trek], [Data], [X], [], [],
    [], [Lore], [], [], [X],
    [Ex Machina], [Kyoko], [], [X], [],
    [], [Ava], [], [X], [],
    [Tron], [Tron], [], [X], [],
    [Neuromancer], [Wintermute], [], [X], [],
    [The Caves of Steel / Naked Sun], [R. Daneel Olivaw], [], [X], [],
    [The Robots of Dawn], [R. Giskard Reventlov], [], [X], [],
    [Portal], [GLaDOS], [], [], [X],
  )]
  , caption: [AIs in different forms of media.]
  , kind: table
  )

=== Voice Assistants
<voice-assistants>
Voice has a visceral effect on the human psyche; since birth we recognize the voice of our mother. The voice of a loved one has a special effect. Voice is a integral part of the human experience. Machines that can use voice in an effective way are closer to representing and affecting human emotions.

#strong[Apple’s Siri and Amazon’s Alexa] are well-known examples of AI technology in the world. Amazon’s Rohit Prasad thinks it can do so much more, "Alexa is not just an AI assistant – it’s a trusted advisor and a companion."

- LLMs combined with voice provide a unnerving user experience #cite(<ethanmollick2023>, form: "prose")
- Ethical issues: Voice assistants need to continuously record human speech and process it in data centers in the cloud.
- Siri, Cortana, Google Assistant, Alexa, Tencent Dingdang, Baidu Xiaodu, Alibaba AliGenie all rely on voice only.
- #cite(<szczukaHowChildrenAcquire2022>, form: "prose") provides guidelines for Voice AI and kids
- #cite(<casperkesselsGuidelinesDesigningInCar2022>, form: "prose");: "Guidelines for Designing an In-Car Voice Assistant"
- #cite(<casperkesselsVoiceInteractionSolution2022>, form: "prose");: "Is Voice Interaction a Solution to Driver Distraction?"
- #cite(<tangSemanticReconstructionContinuous2022>, form: "prose") reports new findings enable computers to reconstruct language from fMRI readings. - Focus on voice education?

– LLM evaluation: https:\/\/www.trulens.org/ #cite(<leinoInfluenceDirectedExplanationsDeep2018>, form: "prose") – https:\/\/docs.ragas.io/ "Metrics-Driven Development" – https:\/\/www.langchain.com/langsmith

\- @CELINO2020102410[:];\] There’s research suggesting that voice UI accompanied by a #emph[physical embodied system] is preffered by users in comparison with voice-only UI. This suggests adding an avatar to the AI design may be worthwhile.

There’s evidence across disciplines about the usefulness of AI assistants:

- @SERBAN20202849 suggests using the Alexa AI assistant in #emph[education] during the pandemic, supported students and teachers 'human-like' presence. Standford research: "humans expect computers to be like humans or places"
- @CELINO2020102410 found in testing chatbots for survey interfaces that "\[c\]onversational survey lead to an improved response data quality."

=== AI Friends and Roleplay (Anthropomorphic)
<ai-friends-and-roleplay-anthropomorphic>
Calling a machine a friend is a proposal bound to turn heads. But if we take a step back and think about how children have been playing with toys since before we have records of history. It’s very common for children to imagine stories and characters in play - it’s a way to develop one’s imagination #strong[#emph[learn through roleplay];];. A child might have toys with human names and an imaginary friend and it all seems very normal. Indeed, if a child doesn’t like to play with toys, we might think something is wrong.

Likewise, inanimate objects with human form have had a role to play for adults too. Anthropomorphic paddle dolls have been found from Egyptian tombs dated 2000 years B.C. #cite(<PaddleDollMiddle2023>, form: "prose");: We don’t know if these dolls were for religious purposes, for play, or for something else, yet their burial with the body underlines their importance.

Coming back closer to our own time, Barbie dolls are popular since their release in 1959 till today. Throughout the years, the doll would follow changing social norms, but retain in human figure. In the 1990s, a Tamagotchi is perhaps not a human-like friend but an animal-like friend, who can interact in limited ways.

How are conversational AIs different from dolls? They can respond coherently and perhaps that’s the issue - they are too much like humans in their communication. We have crossed the #strong[#emph[Uncanny Valley];] (where the computer-generated is nearly human and thus unsettling) to a place where is really hard to tell a difference. And if that’s the case, are we still playing?

Should the AI play a human, animal, or robot? Anthropomorphism can have its drawbacks; humans have certain biases and preconceptions that can affect human-computer interactions @pilacinskiRobotEyesDon2023 reports humans were less likely to collaborate with red-eyed robots.

The AI startups like Inworld and Character.AI have raised large rounds of funding to create characters, which can be plugged in into online worlds, and more importantly, remember key facts about the player, such as their likes and dislikes, to generate more natural-sounding dialogues #cite(<wiggersInworldGenerativeAI2023>, form: "prose")

- #cite(<lenharoChatGPTGivesExtra2023>, form: "prose") experimental study reports AI productivity gains, DALL-E and ChatGPT are qualitatively better than former automation systems.

#strong[Human-like]

Is anthropomorphism necessary?

As AIs became more expressive and able to to #strong[roleplay];, we can begin discussing some human-centric concepts and how people relate to other people. AI companions, AI partners, AI assistants, AI trainers - there’s are many #strong[roles] for the automated systems that help humans in many activities, powered by artificial intelligence models and algorithms.

- RQ: Do college students prefer to talk to an Assistant, Friend, Companion, Coach, Trainer, or some other Role?

- RQ: Are animal-like, human-like or machine-like AI companions more palatable to college students?

Humans (want to) see machines as human \[ADD CITATION\]

If we see the AI as being in human service. #cite(<davidjohnstonSmartAgentProtocol2023>, form: "prose") proposes #strong[#emph[Smart Agents];];, "general purpose AI that acts according to the goals of an individual human". AI agents can enable #strong[#emph[Intention Economy];] where one simply describes one’s needs and a complex orchestration of services ensues, managed by the the AI, in order to fulfill human needs #cite(<searlsIntentionEconomyWhen2012>, form: "prose");. AI assistants provide help at scale with little to no human intervention in a variety of fields from finance to healthcare to logistics to customer support.

There is also the question of who takes responsibility for the actions take by the AI agent. "Organization research suggests that acting through human agents (i.e., the problem of indirect agency) can undermine ethical forecasting such that actors believe they are acting ethically, yet a) show less benevolence for the recipients of their power, b) receive less blame for ethical lapses, and c) anticipate less retribution for unethical behavior." #cite(<gratchPowerHarmAI2022>, form: "prose")

- Anthropomorphism literature #cite(<liAnthropomorphismBringsUs2021>, form: "prose") "high-anthropomorphism (vs.~low-anthropomorphism) condition, participants had more positive attitudes toward the AI assistant, and the effect was mediated by psychological distance. Though several studies have demonstrated the effect of anthropomorphism, few have probed the underlying mechanism of anthropomorphism thoroughly"
- #cite(<erikbrynjolfssonTuringTrapPromise2022>, form: "prose") "The Turing Trap: The Promise & Peril ofHuman-Like Artificial Intelligence"
- #cite(<xuWeSeeMachines2018>, form: "prose") "Do We See Machines TheSame Way As We See Humans? A Survey On Mind Perception Of Machines AndHuman Beings"
- #cite(<martinez-plumedFuturesArtificialIntelligence2021>, form: "prose") envisions the future of AI "Futures of artificial intelligence through technology readiness levels"
- The number of AI-powered assistants is too large to list here. I’ve chosen a few select examples in the table below.

#strong[Animal-like: Some have an avatar, some not. I’ve created a framework for categorization. Human-like or not… etc]

#strong[Machine-like]

The Oxford Internet Institute defines AI simply as #strong[#emph["computer programming that learns and adapts"];] #cite(<googleAZAI2022>, form: "prose");. Google started using AI in 2001, when a simple machine learning model improved spelling mistakes while searching; now in 2023 most of Google’s products are are based on AI #cite(<googleGooglePresentsAI2022>, form: "prose");. Throughout Google’s services, AI is hidden and calls no attention itself. It’s simply the complex system working behind the scenes to delivery a result in a barebones interface.

#figure(
  align(center)[#table(
    columns: (26.39%, 41.67%, 31.94%),
    align: (auto,auto,auto,),
    table.header([Product], [Link], [Description],),
    table.hline(),
    [Github CoPilot], [personal.ai], [AI helper for coding],
    [Google Translate], [translate.google.com], [],
    [Google Search], [google.com], [],
    [Google Interview Warmup], [grow.google/certificates/interview-warmup], [AI training tool],
    [Perplexity], [#cite(<hinesPerplexityAnnouncesAI2023>, form: "prose");], [perplexity.ai chat-based search],
  )]
  , kind: table
  )

Everything that existed before OpenAI’s GPT 4 has been blown out of the water.

Pre-2023 literature is somewhat limited when it comes to AI companions as the advantage of LLMs has significantly raised the bar for AI-advisor abilities as well as user expectations. Some relevant papers include a comparison of robot advisors by @barbarafriedbergM1FinanceVs2021 and @slackAturaProcess2021’s account of how before Generative AI, financial chatbots were developed manually using a painstaking process that was slow and error-prone, for example using the Atura Process. Older financial robo-advisors, built by fintech companies aiming to provide personalized suggestions for making investments such as Betterment and Wealthfront are forced to upgrade their technology to keep up.

Some evergreen advice most relates to human psychology which has remained the same. @haugelandUnderstandingUserExperience2022 discusses #strong[#emph[hedonic user experience];] in chatbots and @stephhayEnoFinancialAI2017 explains the relationship between emotions and financial AI.

- #cite(<eugeniakuydaReplika2023>, form: "prose") Conversational AI - Replika

- #cite(<greylockOpenAICEOSam2022>, form: "prose") Natural language chatbots such as ChatGPT

- #cite(<nathanbenaichStateAIReport2022>, form: "prose") State of AI Report

- #cite(<neuralnineFinancialAIAssistant2021>, form: "prose") Financial AI assistant in Python

- #cite(<davidExplainableAIAdoption2021>, form: "prose") Can explainable AI help adoption of Financial AI assistants?

- #cite(<qorusGreatReinventionGlobal2023>, form: "prose") Digital banking revolution

- #cite(<lowerChatbotsTooGood2017>, form: "prose") "Chatbots: Too Good to Be True? (They Are, Here’sWhy)."

- #cite(<brownHowFinancialChatbots2021>, form: "prose") Financial chatbots

- #cite(<isabellaghassemismithInterviewDanielBaeriswyl2019>, form: "prose")

- #cite(<josephinewaktareheintzCleo>, form: "prose") Cleo copywriter

- Smaller startups have created digital companions such as Replika (fig.~8), which aims to become your friend, by asking probing questions, telling jokes, and learning about your personality and preferences - to generate more natural-sounding conversations.

=== Fitness Guides
<fitness-guides>
- #strong[AI Guides have been shown to improve sports performance, etc, etc. Can this idea be applied to sustainability? MyFitness Pal, AI training assistant. There’s not avatar.]

=== CO2 Calculators
<co2-calculators>
We have a limited carbon budget so calculating CO2e-cost become integrated into every activity.

- CO2e calculations will be part of our everyday experience

- Personal carbon footprint calculators have been released online, ranging from those made by governments and companies to student projects.

- Zhang’s Personal Carbon Economy conceptualized the idea of carbon as a currency used for buying and selling goods and services, as well as an individual carbon exchange to trade one’s carbon permits @zhangPersonalCarbonEconomy2018.

Personal Carbon Trackers

Similar to personal health trackers, personal CO#sub[2] trackers help one track emissions and suggests sustainable actions.

#figure(
  align(center)[#table(
    columns: (34.72%, 65.28%),
    align: (auto,auto,),
    table.header([App], [Description],),
    table.hline(),
    [Commons (Formerly Joro)], [Finacial Sustainability Tracking + Sustainable Actions],
    [Klima], [Offset Subscription],
    [Wren], [Offset Subscription],
    [JouleBug], [],
    [eevie], [],
    [Aerial], [],
    [EcoCRED], [],
    [Carbn], [],
    [LiveGreen], [],
    [Earth Hero], [],
    [], [],
  )]
  , caption: [A selection of personal sustainability apps. See #emph[greenfilter.app] for an updated database.]
  , kind: table
  )

== Design Implications
<design-implications-3>
This chapter looked at AI in general since its early history and then focused on AI assistants in particular.

#figure(
  align(center)[#table(
    columns: (33.33%, 66.67%),
    align: (auto,auto,),
    table.header([Category], [Implication],),
    table.hline(),
    [Voice Assistants], [There are many distinct ways how an algorithm can communicate with a human. From a simple search box such as Google’s to chatbots, voices, avatars, videos, to full physical manifestation, there are interfaces to make it easier for the human communicate with a machine.],
    [Sustainability], [While I’m supportive of the idea of using AI assistants to highlight more sustainable choices, I’m critical of the tendency of the above examples to shift full environmental responsibility to the consumer. Sustainability is a complex interaction, where the producers’ conduct can be measured and businesses can bear responsibility for their processes, even if there’s market demand for polluting products.],
    [Sustainability], [Personal sustainability projects haven’t so far achieved widespread adoption, making the endeavor to influence human behaviors towards sustainability with just an app - like its commonplace for health and sports activity trackers such as Strava (fig.~9) -, seem unlikely. Personal notifications and chat messages are not enough unless they provide the right motivation. Could visualizing a connection to a larger system, showing the impact of the eco-friendly actions taken by the user, provide a meaningful motivation to the user, and a strong signal to the businesses?],
    [Machine Learning], [All of the interfaces mentioned above make use of machine learning (ML), a tool in the AI programming paradigm for finding patterns in large sets of data, which enables making predictions useful in various contexts, including financial decisions. These software innovations enable new user experiences, providing an interactive experience through chat (chatbots), using voice generation (voice assistants), virtual avatars (adds a visual face to the robot).],
    [Character Design], [I’m a digital companion, a partner, an assistant. I’m a Replika.” said Replika, a digital companion app via Github CO Pilot, another digital assistant for writing code, is also an example of how AI can be used to help us in our daily lives.],
    [Psychology], [Humans respond better to humans?],
    [Psychology], [Humans respond better to machines that into account emotion?],
    [Open Source], [For public discussion to be possible on how content is displayed, sorted, and hidden, algorithms need to be open source.],
    [User Experience], [User experience design (AI UX) plays a crucial role in improving the consumer to investing journey. The missed opportunity to provide an even more interactive experience in line with user expectations.],
    [LLMs], [Prompt engineering findings have significance for "green filter" as it validates the idea of creating advanced prompts for improved responses. For "green filter", the input would consist of detailed user data + sustainability data for detailed analysis.],
    [Cuteness], [Cuter apps have higher retention?],
    [Transparency], [Understanding algorithm transparency helps humans to regard the AI as a machine rather than a human],
    [Anthropomorphism?], [],
    [], [],
    [], [],
    [], [],
    [], [],
    [], [],
    [], [],
    [], [],
  )]
  , caption: [Design implications arising from this chapter.]
  , kind: table
  )

#horizontalrule

title: Money sidebar\_position: 4 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

== Where Does Money Come From?
<where-does-money-come-from>
Money is a system of trust where #emph[something] is used as a medium of value exchange and accepted by #emph[other people] as payment.

Traditionally it’s created by governments by law using central banks which loan money to commercial banks. New types of money are increasingly created by companies and even individuals using cryptography methods such as blockchains to keep track of who-paid-whom.

== Shopping, Saving and Investing are Forms of Capital Allocation
<shopping-saving-and-investing-are-forms-of-capital-allocation>
Sustainable Capital Allocation. Shopping, Saving, Investing are all forms of capital allocation. We’re giving our money to companies.

== Sustainability Lacks Trillions in Investment
<sustainability-lacks-trillions-in-investment>
– compliance and GenAI in banking: @rahulagarwalHowGenerativeAI2024.

– "Lessons from banking to improve risk and compliance and speed up digital transformations" @jimboehmBetterRiskControls2021.

The theme for the 2023 Earth Day was #emph["Invest In Our Planet"];. The estimate for the global #strong[financing gap for low-carbon energy production in 2016 was 5.2 Trillion USD] @MappingGapRoad2016@earthdayEarthDay20232023. A newer United Nations Environmental Programme (UNEP) calculation lowered the world needs an additional #strong[4.1 Trillion USD] of financing in nature-based solution by 2050 to meet climate change, biodiversity, and land degradation targets @unepUNEPGreenFinance2022. And according to @therockefellerfoundationWhatGetsMeasured2022 a slightly lower #strong[2.5-3.2 Trillion USD] would be sufficient.

- Robeco survey of 300 large global investors totalling \$27T under management found biodiversity-protection is increasingly a focus-point of capital allocation @robeco2023GlobalClimate2023.

Even with massive financing going into sustainability, there’s still a lack of investing.

It’s not happening fast enough.

The lack of funding in green energy especially affects emerging economies, reminds us #cite(<MobilizingCapitalEmerging2022>, form: "prose");. "We can and must channel private capital into nature-based solutions. This will require policy and regulatory support, catalytic capital and financial innovation" said the CEO Green Finance Institute, Dr Rhian-Mari Thomas, ahead of COP27 in Egypt @GreenFinanceInstitute2023.

What if 10% of consumer spending went for climate?

#figure(
  align(center)[#table(
    columns: (68.06%, 31.94%),
    align: (auto,auto,),
    table.header([High-Value Assets (Trillions of USD)], [],),
    table.hline(),
    [Global Real Estate (2020, valuation)], [\$326T],
    [Global Equity Markets (2023, valuation)], [\$108T],
    [Global GDP (2023, per year)], [\$105T],
    [Global GDP (2022, per year)], [\$100T],
    [#emph[Global Pension Funds (2023, valuation)];], [#emph[\$47.9T];],
    [U.S. Equity Markets (2023, valuation)], [\$46.2T],
    [U.S. National Debt (2023, valuation)], [\$32.6T],
    [#emph[Millennials Inheriting Money from Parents in the U.S., U.K. and Australia (2022-2032)];], [#emph[\$30T];],
    [Global Retail Sales of Goods and Services to Consumers (2023, per year)], [\$28.2T],
    [GDP of U.S.A. (2023, per year)], [\$26.8T],
    [GDP of China (2023, per year)], [\$19.3T],
    [Global Private Market Assets (2023, per year)], [\$11.7T],
    [#emph[Unpriced Externalities (2023, per year)];], [#emph[\$7.3T];],
    [Global E-Commerce Sales (2021, per year)], [\$5.2T],
    [#emph[Missing Climate Invesment (2022, total)];], [#emph[\$4.1T];],
    [Industrial & Commercial Bank of China (2019, total assets)], [\$4T],
    [Global Real Estate Sales (2021, per year)], [\$3.7T],
    [Apple Computers (2023, market value)], [\$3T],
    [GDP of Japan (2023, per year)], [\$4.5T],
    [GDP of Germany (2023, per year)], [\$4.3T],
    [GDP of India (2023, per year)], [\$3.7T],
    [U.S. Gen-Z and Millennials Consumer Spending (2022, per year)], [\$2.5T],
    [#emph[Retail Investors (2023, liquid assets)];], [#emph[\$1.8T];],
    [Blackstone (2023, total assets)], [\$1T],
    [NVIDIA 英偉達 (2023, market value)], [\$0.9T],
    [GDP of Taiwan (2023, per year)], [\$0.8T],
    [Bitcoin (2023, market cap)], [\$0.5T],
    [GDP of Finland (2023)], [\$0.3T],
    [Ethereum (2023, market cap)], [\$0.2T],
    [GDP of Estonia (2023, per year)], [\$0.04T],
  )]
  , caption: [Comparative data on needed climate investment and other valuable assets; all figures in Trillions of USD #cite(label("s&pglobalWorld100Largest2019"));@grandviewresearchRealEstateMarket2021@aarononeillGlobalGDP198520282023@IMFWorldEconomicOutlook2023@stephanieaaronsonHowAppleBecame2023@statistaRetailMarketWorldwide2023@statistaGlobalRetailEcommerce2021@sifmaResearchQuarterlyEquities2023@ustreasuryFiscalDataExplains2023@raoVisualizing105Trillion2023@thinkingaheadinstituteGlobalPensionAssets2023@blockworksBitcoinPriceBTC2023@blockworksEthereumPriceETH2023#cite(label("mckinsey&companyMcKinseyGlobalPrivate2023"));@oguhBlackstoneReachesRecord2023@foxRetailInvestorsWill2023@trucostNaturalCapitalRisk2023]
  , kind: table
  )

The needed investment doesn’t seem so large, around 2.5-5.2 % of the global GDP, if one compares it to the #emph[per year] Global Gross Domestic Product (GDP) estimated at around 100 Trillion USD in 2022 and growing to 105 Trillion USD in 2023 @aarononeillGlobalGDP198520282023@IMFWorldEconomicOutlook2023. In essence, the estimated total investment gap in climate fits into the economic growth of 1 year of the global economy.

=== Economics
<economics>
The first two decades of the 21st century have seen a flurry of new economic thinking, looking to challenge, improve or upgrade capitalism to match our current environmental, social, and technological situation, often called #strong[#emph[New Economics.];] Some of these include behavioral economics, sustainable capitalism, regenerative capitalism, doughnut economics, ecological economics, blue economy, degrowth, attention economy, gift economy, intent economy, among others. There’s no lack of published books on changing capitalism, which goes to show there’s readership for these ideas. Build a new economic theory is out of scope for my thesis design, however I’ll focus on the parts of economic theory I believe are relevant for #emph[interaction design];-ing for sustainability.

=== Is Decoupling Economic Growth and CO2e Emissions Possible?
<is-decoupling-economic-growth-and-co2e-emissions-possible>
- @keysserDegrowthScenariosSuggest2021 provides several scenarios for low, medium, and high levels of decoupling.
- @harrissonAnalysisWhyUK2019 concludes UK’s CO2e emissions have fell 43% from 1990 to 2017 through use of less carbon-intensive energy sources and thu argues for moderate policies in @hausfatherEmissionsBusinessUsual2020 while @globalcarbonbudgetCumulativeCOEmissions2023 data shows an increasing CO2e emissions trend in the UK in the same timeline.
- Green Growth Is Green Growth an oxymoron?

==== New Metrics
<new-metrics>
- In Taiwan, the #emph[FTSE4Good TIP Taiwan ESG Index] tracks ESG-rated companies on the Taipei stock market @taiwanindexTIPTaiWanZhiShuGongSi2024.

Degrowth proponents are pessimistic it’s possible to decouple greenhouse gas emissions from economic growth; historical data shows does not show any decoupling. Some data from China shows decoupling?

Econometrics is the science and art of measuring the economy. There has been ongoing work to create improved metrics such as the the Sustainable Development Goals (SDGs), Human Development Index (HDI), Genuine Progress Indicator (GPI), Green GDP, Inclusive Wealth Index, and others @bleysBarriersOpportunitiesAlternative2015@kovacicGDPIndicatorsNeed2015@anielskiMeasuringSustainabilityNations2001.

The creator of the Gross Domestic Product (GDP) metric in 1934 Simon Kuznets said: "The welfare of a nation can scarcely be inferred from a measurement of national income as defined by GDP…Goals for 'more' growth should specify of what and for what" @unitedstates.bureauofforeignanddomesticcommerceNationalIncome192919321934. GDP was the culmination of previous work by many authors, beginning with William Petty in the 17th century #cite(<rockoffGoodStartNBER2020>, form: "prose");. This long journey underlines how a metric about a complex system such as the economy is continuous work in progress.

There are those looking for new metrics. One of the first innovators, already in 1972, was Buthan, with the #emph[Gross National Happiness Index (GNH)];, which in turn inspired the UN, decades later, in 2012, to create the International Wellbeing and Happiness Conference and the International Happiness Day@ribeiroGrossNationalHappiness2017@kameiUrbanizationCarbonNeutrality2021. The Wellbeing Economy Alliance (WEAll) countries (New Zealand, Iceland, Finland, Scotland, Wales) as well as the EU and Canada, started the coalition in 2018 @ellsmoorNewZealandDitches2019@davidsuzukifoundationWellbeingEconomies2021@ceprFairSustainableProsperous2022@scottishgovernmentWellbeingEconomyGovernments2022@wellbeingeconomyallianceWhatWellbeingEconomy2022. The World Bank talks about the comprehensive GDD+ metrics in its Changing the Wealth of Nations report @worldbankChangingWealthNations2021. #cite(<giacaloneWellbeingAnalysisItalian2022>, form: "prose") looks at wellbeing of Italian communities and proposes a new composite index.

The award-winning economist Mariana Mazzucato argues in #cite(<guptaElectrifyingEconomistGuide2020>, form: "prose") we have to include more into how we value unpaid labor, relating to the social (S in ESG) @mazzucatoValueEverythingMaking2018.

New economic thinkers are asking how can economic growth and sustainability be compatible. Some even ask if #emph[economic growth] itself is the wrong goal? @diduchEconomicGrowthWrong2020. Degrowth is the most famous contender in that branch of economics.

We should measure wellbeing in addition to GDP and the metric should including resiliency dashboards, to to visualize metrics beyond GDP and they are an integral part of country reports @greensefaBeyondGrowthChangingGoal2023. Similarly, the doughnut (donut) economics (more below) model calls for a "dashboard of indicators" @tedHealthyEconomyShould2018.

- Trucost, a company lauched in 2000 to calculate the hidden environmental costs of large corporations and advance circular-economy practices was acquired in 2016 by S&P Dow Jones Indices, which by 2019 became a part of its ESG product offering @toffelTrucostValuingCorporate2011@mikehowerTrucostTruValueLabs2015@indicesDowJonesIndices2016@RollsOutTrucost2019. It’s parent company S&P Global also acquired RobecoSAM’s ESG rating business, consolidating S&P’s control of ESG ratings @georgegeddesGlobalAcquiresRobecoSAM2019.

- @trucostNaturalCapitalRisk2023 finds the value of unpriced externalities which are not included in the GDP is 7.3 trillion USD per year.

- The Progress Principle is a term coined by Teresa Amabile and Steven Kramer, says people like to see the number go up. #cite(<amabileProgressPrincipleUsing2011>, form: "prose")

- Capital misallocation

- Securitization

- ESG greenwashing #cite(<baldiRoleESGScoring2022>, form: "prose")

==== Ecological Economics
<ecological-economics>
Ecological economics is the prime suspect for eco-conscious ideas to incorporate into design, drawing attention to the interdependence of economy and the ecosystem; there are physical limits to economic growth on a planet with finite resources. The founder of the field Herman Daly was talking about #emph[prosperity without growth] more than two decades ago, focusing on the diminishing natural resources @dalyGrowthEconomicsSustainable1997. @jacksonProsperityGrowthEconomics2009@jacksonProsperityGrowthFoundations2017 expanded on these ideas with recipes for a post-growth world, making the ideas seem more tangible and precise.

==== Doughnut Economics
<doughnut-economics>
The doughnut (donut) is a simple visualization that helps to grasp the big picture of the economy and the physical and social worlds. It allows one to see the social shortfall and ecological overshoot of nations at the same time @fanningSocialShortfallEcological2021. Doughnut Economics has not been implemented on a country–level however has inspired cities to take a comprehensive view of the doughnut of their own city.

Several EU cities have adopted the vision @teicherDoughnutEconomicsHas2021. Doughnut in Brussels, Belgium. Everything has to be adapted to the place and context @oikosdenktankWebinarDoughnutEconomics2021@brusselsdonutHomeBrusselsDonut2022. The city of Amsterdam is developing shorter food chains (which save CO#sub[2];) and linking residents with food production and reconnecting people to the food. Food become a sort of #strong[#emph[social object];];, which foster collaboration in the community @circleeconomyKeynoteIlektraKouloumpi2021. Amsterdam also has a Circular Economy Monitor which makes it easy for anyone to see the progress being made towards the Dutch goal to be a circular economy by 2050 @waterstaatCircularDutchEconomy2019@gemeenteamsterdamCircularEconomyMonitor2022.

The Doughnut concept is a useful social object that’s simple and deep at the same time, enabling starting conversations with people from all walks of life, independent of their politics leanings. As Raworth calls it, it’s a #strong[#emph["self-portrait of humanity in the beginning of the 21st century".];] Combining the SDGs inside the doughnut and the Planetary Boundaries outside the doughnut. The space donut represents a state of equilibrium and balance on spaceship Earth.

- Kate Raworth was inspired by ecological economics among other things.
- #cite(<baileyMappingActorsArguments2020>, form: "prose") shows how the Norwegian government plans to increase salmon production 5x by 2050. How can this be sustainable?
- #cite(<gadlevanonDonutEffectReal2022>, form: "prose") the donut effect is real, shift away from city centers. Not related to donut economy per se.
- #cite(<salaEnvironmentalSustainabilityEuropean2020>, form: "prose")
- Resource footprint, ecological footprint
- #cite(<oliverSafeJustOperating2022>, form: "prose")
- Donut quantified #cite(<luukkanenQuantificationDoughnutEconomy2021>, form: "prose")
- #cite(<defidonutPoolTogether732021>, form: "prose") Savings Lottery
- #cite(<jolijnhooghwinkelVergeetGroteBedrijven2023>, form: "prose") donut essay winner
- #cite(<RaworthDoughnut2021>, form: "prose") Donut in practice
- #cite(<bbcreelHowDutchAre2020>, form: "prose")
- #cite(<circleeconomyKeynoteIlektraKouloumpi2021>, form: "prose")
- #link("https://www.c40.org/") city coalition
- #cite(<goliasDonutCenteredDesign2019>, form: "prose")

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    table.header([Short Food Chains in Amsterdam],),
    table.hline(),
    [Spatial planning for food place-making in the city],
    [Circular agriculture],
    [Regionally produced food],
    [Collaboration between chain members],
    [Food education],
  )]
  , caption: [From #cite(<circleeconomyKeynoteIlektraKouloumpi2021>, form: "prose");.]
  , kind: table
  )

- #cite(<AmsterdamUses2023>, form: "prose")

- #cite(<wetenschappelijkbureaugroenlinksKateRaworthDoughnut2023>, form: "prose")

- 100 cities generate more than 70% of their electricity, circular city design

- Circular City Currency

- Earth’s ecological ceiling

- Doughnut Economics Action Lab

- #cite(<raworthDoughnutEconomicsSeven2017>, form: "prose") book

- Doughnut economics’ #cite(<bbcreelHowDutchAre2020>, form: "prose")

- Donut and Design Thinking both focus on sustainability and human-centeredness.

- #cite(<horwitzThereHoleMiddle2017>, form: "prose") critics would say doughnut economics would expand the role of the government

==== Regenerative Capitalism
<regenerative-capitalism>
- #cite(<fullerGrunchGiants1983>, form: "prose");: "Nature is a totally efficient, self-regenerating system. If we discover the laws that govern this system and live synergistically within them, sustainability will follow and humankind will be a success."

- #cite(<RegenerativeCapitalismNew2023>, form: "prose") "The quality of growth matters". #cite(<johnfullertonJohnFullertonWhen2011>, form: "prose");: John Fullerton: Balance efficiency with resiliency so the whole system doesn’t become brittle and break. #cite(<johnfullertonRegenerativeBusinessPart2022>, form: "prose");: "human civilization is embedded in the biosphere". Fullerton builds on the ideas of Club of Rome and #cite(<meadowsLimitsGrowthReport1972>, form: "prose");.

- Triodos Bank

- Global Alliance for Banking on Values

==== Intent Economics
<intent-economics>
- In #emph[intent economics];, could I define what are my expectations towards companies, before I engage in any transactions #cite(<searlsIntentionEconomyWhen2012>, form: "prose");. Old-school businesses only expect me to spend money but I have so many more concerns. I’m human. I’m not just a piece of currency.

- In the context of this study, is it possible to make financial decisions that follow our guidelines and preferences but without moment-to-moment involvement needed so as to save up our precious time?

==== Varia
<varia>
History of money #cite(<fergusonAscentMoneyFinancial2009>, form: "prose")

Externalities need to be priced in.

metrics and goals: ESG, SDGs,

- Celo’s protocol invests in carbon credits on the protocol level: #cite(<CeloRegenerativeFinance2021>, form: "prose")

- #cite(<mazzucatoMissionEconomyMoonshot2021>, form: "prose")

- #cite(<krausmannResourceExtractionOutflows2018>, form: "prose")

- #cite(<WhatRegenerativeCapitalism2022>, form: "prose")

- #cite(<support_llBookReviewGreen2021>, form: "prose")

- #cite(<pauliBlueEconomyMarriage2017>, form: "prose") Blue economy

- #cite(<standingBlueCommonsRescuing2022>, form: "prose")

- #cite(<bullerValueWhaleIllusions2022>, form: "prose")

- #cite(<pauliBlueEconomyMarriage2017>, form: "prose")

- #cite(<lovinsFinerFutureCreating2018>, form: "prose")

- #cite(<bardiLimits50Years2022>, form: "prose")

- #cite(<circlRegenerativeEconomicsReset2021>, form: "prose")

- #cite(<michaelkramerTEDxHiloMichaelKramer2012>, form: "prose")

- #cite(<elkingtonGreenSwansComing2020>, form: "prose")

- #cite(<stockholmresiliencecentretvKateRaworthPresenting2017>, form: "prose")

- Adam Smith: Interdependence

== Indexes Enable Comparing Companies
<indexes-enable-comparing-companies>
Does certification matter? Consumers are willing to pay more for bio-based products "72% of Europeans are willing to pay more for environmentally friendly products. The study identifies a"green premium” and a "certified green premium," indicating increased WTP for bio-based and certified bio-based products.” #cite(<moroneConsumerWillingnessPay2021>, form: "prose") (need access)

- consumer awareness of Sustainable supply chains, Italian consumers have a strong preference for antibiotic-free meat @mazzocchiConsumerAwarenessSustainable2022.

Indexes make comparison possible. There are many-many Indexes, Scoring Systems, Ratings, Certifications, etc.

- Rating Systems: Companies assess customer’s credit score, however how can customers rate companies.
- ESG Shopping: "Changing our relationship with money"

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Rating System], [Link],),
    table.hline(),
    [B Corporation], [],
    [ESG], [],
    [Fair Trade], [],
    [Responsible Business Index], [],
    [Greenly], [],
  )]
  , kind: table
  )

There are many different certifications

- #cite(<EthicalConsumer>, form: "prose")

- B Impact Assessment

- sustainable brands

- Fair Trade

- #cite(<GreenWebFoundation2023>, form: "prose") For example, the Green Web Foundation certifies how sustainable is the web hosting used by websites.

- #cite(<EstonianResponsibleBusiness>, form: "prose") Responsible business index

- Testing website CO#sub[2] emissions #cite(<wholegraindigitaHowDoesIt2023>, form: "prose")

- Greenly Decarborization Index #cite(<greenlyGreenlyIntroducesClimate2023>, form: "prose")

- ESG Criticism "25 ESG ratings from three major providers (Moody’s Analytics, MSCI Inc., and Refinitiv)" - "well-rated companies do not emit significantly less carbon than those with lower scores."

- ESG reports are very general and opaque. We need product-level analytics and reporting to be able to compare products.

- Product-level reporting can be a basis for investing in companies. "Product-investing". I want to invest in particular products.

- Google Environmental Insights Explorer enables local governments (cities) to measure CO2 emissions and enact environental policies that optimize city functions such as traffic flows @MethodologyGoogleEnvironmental@nicolelombardoReducingCityTransport2021

- ESG apps in Singapore:

- DBS LiveBetter consumer sustainbility app @dbssingaporeDBSLiveBetter@dbsDBSLaunchesSingapore2018

- https:\/\/www.gprnt.ai/

ESG Complicance Systems: - MEET - EXCEED - LEAD

Existing rankings

- #cite(<earth.orgWorld50Most2022>, form: "prose")
- #cite(<staff2021Global1002021>, form: "prose")

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([References], [What it does],),
    table.hline(),
    [#cite(<leafscoreLeafScoreLeadingOnline2023>, form: "prose");], [Leafscore for product],
    [#cite(<EthicalConsumer>, form: "prose");], [Ethical consumer ratings],
    [], [],
  )]
  , kind: table
  )

- #cite(<francesschwartzkopffFirmsArenReporting2022>, form: "prose") "Companies in industries with the biggest carbon footprints aren’t reporting how their emissions feed into financial risk, according to an analysis of corporate reports by the Carbon Tracker Initiative."

- Fashion brand ratings

- B Impact Assessment

- Ethical Shopping

- #cite(<Top100Consumer>, form: "prose") Largest consumer goods companies

=== B Corporations
<b-corporations>
B Corporations undergo strict assessment and adhere to stringent sustainability practices.

- #cite(<FindCorp>, form: "prose") BCorporation listings by country
- #cite(<EtsyMadeMistakes2017>, form: "prose")
- #cite(<citywealthESGBrandingBCorps2021>, form: "prose")
- #cite(<SocialEnterprisesCorps>, form: "prose")
- #cite(<ravenpackCorpMovementESG2021>, form: "prose")

=== Product Databases
<product-databases>
All of the world’s products are subject to one or another standard and although they are not uniform, there’s some documentation existing about every product.

- #cite(<OpenProductData>, form: "prose");: Open Knowledge Foundation’s Open Product Data website shut down
- #cite(<hakonbogenThereGlobalDatabase2016>, form: "prose");: "Is there a global database of all products with EAN 13 barcodes?"
- #cite(<gs1EANUPCBarcodes>, form: "prose") EAN/UPC barcodes on most consumer products
- #cite(<semantics3WhyUPCDoesn2017>, form: "prose")
- World product database
  - #cite(<DatakickOpenProduct>, form: "prose");: "open product database"

  - #cite(<WIPOGREENGlobal>, form: "prose") green tech database

  - #cite(<PackagingWorld>, form: "prose") packaging database

=== Sustainability Standards
<sustainability-standards>
- Most sustainable companies. Make a database?

- #cite(<internationaltradecentreStandardsMap2022>, form: "prose") currently lists 334 different sustainability standards: "Towards a meaningful economy" "The world’s largest database for sustainability standards", "We provide free, accessible, comprehensive, verified and transparent information on over 300 standards for environmental protection, worker and labor rights, economic development, quality and food safety, as well as business ethics."

- There have been concerns about food safety in Taiwan

- #cite(<SustainabilityIntelligenceFood>, form: "prose")

- #cite(<OpenFoodFacts>, form: "prose") app for nutrition and sustainability data

== Banks and Fintechs Capture User Data
<banks-and-fintechs-capture-user-data>
Banks have access to each person’s financial habits which makes it possible to model sustainable behavior using big data analysis. Taiwan’s O Bank makes use of Mastercard’s data to calculate each transaction’s CO#sub[2] emissions@TaiwanOBankLaunches2022.

- Banks have started offering a service to automatically save and invest tiny amounts of money collected from shopping expenses. Every purchase one makes contributes a small percentage - usually rounded up to the nearest whole number - to one’s investment accounts. For example, #cite(<swedbankEasySaver2022>, form: "prose");, the leading bank in the Estonian market, offers a savings service where everyday payments made with one’s debit card are rounded up to the next Euro, and this amount is transferred to a separate savings account. Similarly, the Estonian bank #cite(<lhvMicroinvestmentGrowthAccount2020>, form: "prose") offers micro-investing and micro-savings services, with an interesting user experience innovation showing how for an average Estonian means additional savings of about 400€ per year.

- While the financial industry is highly digitized, plenty of banks are still paper-oriented, running digital and offline processes simultaneously, making them slower and less competitive, than startups. Indeed, the new baseline for customer-facing finance is set by fintech, taking cues from the successful mobile apps in a variety of sectors, foregoing physical offices, and focusing on offering the best possible online experience for a specific financial service, such as payments.

- fundamenta analysis such as the Piotroski F-score is not effective for startups because of high capital burn rates.

Banks and Fintech are becoming more similar than ever.

- 39% of Millenials are willing to leave their bank for a better fintech (n=4,282); innovation in payments helps retention @pymntsStayingAheadPayments2023.

- The European Central Bank describes fintech as improving the user experience across the board, making interactions more convenient, user-friendly, cheaper, and faster. "Fintech has had a more pronounced impact in the payments market \[…\] where the incumbents have accumulated the most glaring shortcomings, often resulting in inefficient and overpriced products," Yves Mersch, Member of the Executive Board of the ECB says in #cite(<europeancentralbankLendingPaymentSystems2019>, form: "prose");.

- There are far too many #strong[#emph[neobanks];];, or challenger banks to list. The table only includes a small sample of banks and the landscape is even larger if one includes the wider array of fintechs. Neo-banks often use sustainability marketing.

- O bank carbon calculator (Brasil): "Consumer Spending Carbon Calculator" and "Low-Carbon Lifestyle Debit Card"

- The following popular (totaling millions of users) robo-advisory apps combine sustainability, personalization, ethics, and investing (fig.~6) - however, they are mostly only available on the US market:

#figure(
  align(center)[#table(
    columns: (25.68%, 48.65%, 25.68%),
    align: (auto,auto,auto,),
    [Service], [Features], [Availability],
    [Goodments], [Matching investment vehicles to user’s environmental, social, ethical values], [USA],
    [Wealthsimple], [AI-assisted saving & investing for Millennials], [USA, UK],
    [Ellevest], [AI-assisted robo-advisory focused on female investors and women-led business], [USA],
    [Betterment], [AI-assisted cash management, savings, retirement, and investing], [USA],
    [Earthfolio], [AI-assisted socially responsible investing], [USA],
    [Acorns], [AI-assisted micro-investing], [USA],
    [Trine], [Loans to eco-projects], [USA],
    [Single.Earth], [Nature-back cryptocurrency], [Global],
    [Grünfin], [Invest in funds], [EU],
    [M1 Finance], [Finance Super App], [US],
    [Finimize], [Investment research for anyone], [US],
    [NerdWallet], [Financial clarity all in one place], [US],
    [Tomorrow Bank], [Green Banking], [EU],
    [Marcus Invest], [Robo-Advisor], [US],
    [Chipper], [Digital cash app for African markets], [Africa],
    [Lightyear], [Simple UI for Stocks, ETFs, interest from Estonia], [EU],
    [Ziglu], [UK simple investing app], [UK],
    [Selma], [Finnish investing app], [EU],
    [Monzo], [], [UK],
    [Nubank], [], [Brazil],
    [EToro], [], [],
    [Revolut], [From payments to investing], [UK, EU],
    [Mos], [Banking for students], [],
    [Robinhood], [], [US],
    [Mintos], [Buy bonds and loans], [EU],
    [], [], [],
  )]
  , caption: [Data from @ZigluFastSimple@lightyearLightyearInvestingOwn@SelmaYourFinances@MosMoneyApp@monzoOnlineBankingMade2023@NubankFinalmenteVoce. An updated database is available at #link("https://www.greenfilter.app/database")[greenfilter.app/database];.]
  , kind: table
  )

- #cite(<andresenglerBerkshireHathawayInvests2022>, form: "prose")
- Tokenization is similar financial securitization which has been happening for a long time. - Art can be securitized and tokenized #cite(<masterworksHowItWorks2023>, form: "prose") - Blockchai makes this kind of financial engineering easier as any developer can do it; one does not need to be a bank.
- Given the large number of fraud cases in finance, #emph[trust] is the number one concern for users (ADD CITATION). Good design is crucial for creating transparency, and transparency leads to trust.

=== Fintech UX
<fintech-ux>
The user interface and user experience (UI/UX) of consumer–focused investing apps in Europe has improved a lot over the past few years. One may assume the changing landscape is related to the earlier availability of better quality apps available in the US and the disappearance of the 1st generation of investing apps and the lessons learned.

In the early days in Europe, Germany and the United Kingdom led the way with the most robo-advisory usage @cowanRoboAdvisersStart2018. While Germany had 30+ robot-advisors on the market in 2019, with a total of 3.9 billion EUR under robotic management, it was far less than individual apps like Betterment managed in the US @bankinghubRoboAdvisorNew2019. Already in 2017, several of the early robo-advisors apps have shut down in the UK @altfiETFmaticAppDownloaded2017. ETFmatic gained the largest number of downloads by 2017, focusing exclusively on exchange-traded funds (ETFs), tracking stock-market indexes automatically, with much less sophistication, than their US counterparts @altfiETFmaticAppDownloaded2017. The app was bought by a bank in 2021 and closed down in 2023 @altfiBelgiumAionBank2021@silvaETFmaticReview2023@ETFmaticAccountFunding2023.

- While the financial AI companion apps in the US market are ahead globally, they are not yet using many of the user experience innovations that are prevalent on social media platforms targeted at Generation Z and/or Millennials, possibly presenting an opportunity for cross-industry knowledge transfer, from businesses that are traditionally closer to the consumer - such as retailers. Financial AI companion apps have not yet grown to mainstream scale in Asia, Africa, Latin America, and Europe, being for the moment a largely US-based retail investor trend. The apps outside of the US are niche products in a nascent stage, however, they still provide relevant design directions or stories of what to avoid.

- #cite(<WhyDesignKey2021>, form: "prose")

- #cite(<seanmcgowanUXDesignFinTech2018>, form: "prose")

- #cite(<robindhanwaniFintechUIUX2021>, form: "prose")

- #cite(<DesigningFintechApp2021>, form: "prose")

- #cite(<cordeiroDesignNoLonger2016>, form: "prose")

- #cite(<ungrammaryProductDesignCase2020>, form: "prose")

- #cite(<bhatiaRoboAdvisoryIts2020>, form: "prose") For example, in India, research is being conducted on how AI advisors could assist with investors’ erratic behavior in stock market volatility situations, albeit without much success. India had more than 2000 fintechs since 2015 @migozziYouShouldWhat2023.

- Raha maraton etv investeerimissaade.. raadios on ka mingi saade

- Gamestop for climate massively collaborative investing by gen-z?

- But there’s so much capital in large funds retails investor money doesn’t matter at all. does retail money make any difference?

- #cite(<EmpoweringDigitalAsset>, form: "prose");: digital assets bank

- #cite(<BankNewEconomy>, form: "prose");: Crypto bank

- #cite(<finmaApprovalFirstSwiss2021>, form: "prose") First crypto fund

- #cite(<MyclimateYourPartner2023>, form: "prose") calculate climate cost

- #cite(<GreenCentralBanking>, form: "prose")

- #cite(label("swissinfo.ch/ursSwissCryptoValley2022"), form: "prose") "More than half of the Swiss banks plan to offer digital assets services over the next few years."

- #cite(<hydeGiftHowCreative2006>, form: "prose") Money as a gift

=== Robo-Advisors
<robo-advisors>
#emph[Robo-advisors] is a term that was in fashion largely before the arrival of AI assistants and has been thus superseded by newer technologies.

- Ideally, robo-advisors can be more dynamic than humans and respond to changes to quickly and cheaply. Human advisors are very expensive and not affordable for most consumers. #cite(<capponiPersonalizedRoboAdvisingInteractive2019>, form: "prose") argues "The client has a risk profile that varies with time and to which the robo-advisor’s investment performance criterion dynamically adapts". The key improvement of personalizing financial advice is understanding the user’s dynamic risk profile.
- Robo-advisors compete with community investing such as hedge funds, mutual funds, copy-trading, and DAOs with treasuries. Robo-Advisor do not have the type of social proof a community-based investment vehicle has. The question is, does the user trust the robot or a human.
- #cite(<johnssenkeeziVeBeenInvited2022>, form: "prose");: Small stock investments
- Financial empowerment
- Small cash apps like African market Investment Clubs Invest in sustainability with people smarter than myself
- #cite(<PhaseTwoInvesting>, form: "prose")
- #cite(<qayyumrajanESGAnalyticsIntroduction2021>, form: "prose") ESG pulse
- #cite(<NGFS>, form: "prose") Network for Greening the Financial System
- #cite(<smartwealthHowBecomeInvestor2021>, form: "prose") How do consumer become investors? marketing materials say: "One of the greatest hurdles to financial independence is a consumer mindset." One of the greatest hurdles to sustainability is a consumer mindset?
- #cite(<outlawTurnYourCustomers2015>, form: "prose")
- #cite(<malliarisUsingNeuralNetworks1996>, form: "prose") #strong[(Need to pay for paper!)]
- #cite(<CMBNewFuture>, form: "prose") Huawei
- Consumption is ruining the world the world thinking as an investor the investor mindset
- #cite(<Vise2023>, form: "prose") Personalised portfolios
- #cite(<WalletAppsGoogle>, form: "prose") Thai finance app
- #cite(<ThaiFintechAssociation>, form: "prose")
- #cite(<renatocapeljMobileHedgeFund2021>, form: "prose")

=== Programmable Money
<programmable-money>
Cryptocurrencies are the most popular financial action among young people (ADD CITATION) yet in some ways crypto needs even more financial literacy than traditional financial assets.

- Centralized Crypto Exchanges are in essence lending assets from the user. "The piece of the settlement aimed at getting important information to customers is more understandable from a retail protection standpoint. Customers who lend crypto assets to a company in exchange for a promised return should get the information they need to assess the risks against the rewards" @hesterm.peirceSECGovStatement2022.

- Taiwan banks buying cryptocurrencies with credit card because the volatilty makes it similar to gambling @davidattleeBuyingCryptoCredit2022@MiHuoBi2022.

- Volatile national currencies lead people to find other assets to hold.
- Crypto enables financial innovation and financial engineering by anyone with some programming skills.
- People like Turkey losing 75% of the value of their assets when currency collapses, why people buy crypto.
- #cite(<CryptocurrenciesWorldwideStatista>, form: "prose") estimates over 600 million cryptocurrency users worldwide
- #cite(<raidotonissonLHVToiKlientideni2022>, form: "prose") Estonian bank selling Metaverse cryptocurrency Sandbox
- #cite(<martenpollumeesKuhuInvesteeritiLHV2022>, form: "prose") retirement funds invested in crypto
- #cite(<raidotonissonSedaAktsionaridOstaksid2022>, form: "prose") due to a law change Estonian could take out their pensions and invest or spend them however they wanted.

== Shopping
<shopping>
=== Sustainable Shopping
<sustainable-shopping>
Is it possible?

Make use of indexes to compare companies.

- #cite(<weberMobileAppsSustainable2021>, form: "prose") proposes a sustainable shopping guide.
- #cite(<fuentesUnpackingPackageFree2019>, form: "prose") discusses package free shopping.
- #cite(<vanderwalParadoxGreenBe2016>, form: "prose") discusses "status motives make people publicly display sustainable behavior".

=== Shopping Footprint
<shopping-footprint>
- Shop CO2e emissions for each company who i buy from? "get rid of brands"!! cause they hide and lie

- Make commerce more transparent

- #cite(<DecreasingCarbonFootprint2019>, form: "prose")

- #cite(<sallyparkerWantLowerFood2022>, form: "prose")

- "The sustainable market for Fast Moving Consumer Goods is 2.5 Trillion USD, that includes an untapped market opportunity worth 1 Trillion USD. Nearly 40% of customers say they would switch from their current preferred brand to one that offers more transparency"

- #cite(<EUBanForestkilling>, form: "prose") #strong[Ban polluting products campaign success story, EU shops can’t sell deforestation products]

- #cite(<BurningBridgesAllbridges>, form: "prose")

- Current shopping is like having a one-night stand. you barely know the name of your company. You don’t know much about their background. Building consumer feeling of ownership, create meaningful connections between producers and consumers.

- #strong[AI alert];: "The company you’ve purchased from 3x in the past month is owned by Unilevel, which is under investigation for poor labor practicies and deforestation".

- Sustainable Consumerism via Self-Regulation. 2M EUR project for the shopping app.

- Double Eleven is the world’s largest shopping festival @double11festival2023.

- #cite(<klinglmayrSustainableConsumerismSelfRegulation2016>, form: "prose")

- #cite(<emilywaterfieldAppsThatCan2019>, form: "prose")

- Beebag shopping bags made of recycled plastic bottles with a NFC ship that works in conjunction with an app to provide rebates for customers. #cite(<thegreenfactorEP62Gamification2022>, form: "prose")

- #cite(<iginiEnvironmentalImpactOnline2022>, form: "prose") Online Shopping impact. Single’s day, etc. Impossible to turn the tide?

- "Asia is set to account for 50% of the world’s total online retail sales"

- What is the consumer CO#sub[2] contribution? What is the target?

- #cite(<konradA16zCryptoLeads>, form: "prose") "an internet-wide directory of purchasable products, reminiscent of how the much of the world’s music is made available on streaming platform Spotify."

- All the world’s product directory

- #cite(<austinryderHowBecomeInvestor2020>, form: "prose") Define your habits: are you consumer or investor?

- "Learn to notice so we can preserve", "Õpetame märkama, et oskaksime hoida"

- #cite(<franklintempletondistributorsincConsumerCloutDriving2021>, form: "prose")

- Consume pressure to advance ESG regulatory standards to add a baseline ESG dynamic pricing of risk like climate, mandatory climate disclosures, carbon pricing knowing your supply chain, analyze supply chain risk

- #strong[Live more sustainably with 10 minutes per day.]

- #cite(<mckinseyRiseInclusiveConsumer2022>, form: "prose") Inclusive consumer

- "Consumers have increasing power. Where we put our money reinforces certain types of businesses, as conscious consumers we can vote with our dollars. How can we do it？ Sustainable brands, ESG, etc, etc. Pushing highers Standards and choose companies that adopt circular design"

- #cite(<TaiWanSheJiYanJiuYuanTDRIInstagram2021>, form: "prose") and #cite(<HuoDongTongBeiOuXunHuanSheJiLunTanNordicCircular>, form: "prose") Cradle to Cradle Nordic circular design in Taiwan

- #cite(<mckinseyESGEssentialCompanies2022>, form: "prose")

=== Loyalty Schemes
<loyalty-schemes>
Building customer loyalty is a key part of repeat business and financial predictability for any company. Large consumer brands like Starbucks have for long ran successful rewards programs that encourage customers to come back @steinhoffLoyaltyProgramsTravel2021. Could loyalty schemes create a pathway to investing in the company to a strengthen the feeling of connection with the business even further? After all, I’m now a minority owner! Yet in practice, many consumers lack the financial literacy for investing and there are many legislative difficulties for turning loyalty points into investments. It’s easier instead to create a separate cryptocurrency or token program which users could collect and redeem for some benefit.

=== Consumer Activism
<consumer-activism>
Conscious consumers make up a small percentage of the entire consumer public.

@milneMindfulConsumptionThree2020 coins the term mindful consumers, who do research and are aware of the impact of their shopping choices.

==== Individual Climate Action is Ineffective
<individual-climate-action-is-ineffective>
- #cite(<kristiansteensennielsenArgumentsIndividualClimate2022>, form: "prose") #strong[Individual climate action!!!]

- #strong[Give Gen-Z the tools to turn climate anger into positive change to transform companies]

- #cite(<echeverriaGreenMobilityWellbeing2022>, form: "prose") suggests greener modes of mobility.

- #cite(<hymanShoppingChangeConsumer2017>, form: "prose")

- #cite(<brantleyBrewingBoycottHow2021>, form: "prose")

- Contact Kalle Lasn, Culture Jam

- "ESG Accessibility", Large-scale accessibility to ESG,

- increase ESG accessibility

- Shop sustainability in Estonia @lillevaliUuringVastutustundlikkusEesti2022@EstwatchEstwatchiVarskest. Tarbimise jalajälg poes @helensaarmetsTarbimiselSilmagaNahtamatu2021. Offsets at the point of sale @GrenpayHeastaOma.

- #cite(<GreenFintechTrends2020>, form: "prose") report predicts the rise of personalizing sustainable finance, because of its potential to grow customer loyalty, through improving the user experience. Similarly to good design, interacting with sustainable finance for the 'green-minded' demographics, providing a reliable green product is a way to build customer loyalty.

=== Payments are an Entry Point and Source of Consumer Action Data
<payments-are-an-entry-point-and-source-of-consumer-action-data>
- TSouurhe combination of consumption and investment is an access point to get the consumer thinking about investing. Even if the amount are small, they are a starting point for a thought process.
- Payments is the primary way consumers use money.
- Payments is one way consumers can take individual climate action. In the words of a Canadian investment blogger, "every dollar you spend or invest is a vote for the companies and their ethical and sustainability practices" @fotheringhamHowCreateGreener2017.
- M-Pesa in Kenya since 2007 for mobile payments, used by more than 80% of farmers @tyceNeoliberalstatistDivideDrivers2020@parlascaUseMobileFinancial2022. Using digital payments instead of cash enables a new class of experiences, in terms of personalization, and potentially, for sustainability. Asian markets have shown the fastest growth in the use of digital payments @mckinseyNextFrontierAsia2020.
- In Sweden point of sales (PoS) lending is a common practice, and one of the reasons for the success of Klarna, the Swedish banking startup, which has managed to lend money to more consumers than ever, through this improved user experience.
- Taking out loans for consumption is a questionable personal financial strategy at best. If people can loan money at the point of sales, why couldn’t there be 180 degrees opposite service - point of sales investing?
- A Dutch fintech company Bunq offers payment cards for sustainability, provided by MasterCard, which connects everyday payments to green projects, such as planting trees and donations to charities within the same user interface @bunqBunq2020. Sharing a similar goal to Alibaba’s Ant Forest, Bunq’s approach creates a new interaction dynamic in a familiar context (card payments), enabling customers to effortlessly contribute to sustainability. However, it lacks the level of gamification which makes Alibaba’s offering so addictive, while also not differentiating between the types of purchases the consumer makes, in terms of the level of eco-friendliness.
- From Shopping to Investing #cite(<AcornsTargetsMillennials>, form: "prose") suggests "Targeted at millennials, Acorns is the investing app that rounds up purchases to the nearest dollar and invests the difference."
- #cite(<ContactlessPaymentsPrevalent2023>, form: "prose") in Macau Contactless Payments:
- Commons, formerly known as Joro, analysis your financialss to estimate your CO#sub[2] footprint. #cite(<chantPersonalCarboncuttingApp2022>, form: "prose")

#cite(<FirstPaperMoney>, form: "prose") China was a money innovator introducing paper money in the Tang Dynasty (618–907 AD).

- #cite(<CentralBankDigital2023>, form: "prose") Digital currencies make tracking easier

- E-Naira find papers

- #cite(<yahoofinanceChallengesFacingChina2022>, form: "prose");: WeChat, Alipay, vs digital yuan by Eswar Prasad

- #cite(<marisaadangilCriptomoedasVaoAcabar2022>, form: "prose")

- #cite(<caiojobimBitcoinFalhouCriptomoedas2022>, form: "prose")

- Digitalisation of payments creates lots of Point of Sale (PoS) data that would be valuable to understand what people buy.

- #cite(<EuropeanFintechsWatch2022>, form: "prose")

People are concerned with digital payments

- Digital Currency #cite(<emeleonuNigeriaCapsATM2022>, form: "prose") reports how in order to promote eNaira use, the Nigerian government limited the amount of cash that can be withdrawn from ATMs. "In Nigeria’s largely informal economy, cash outside banks represents 85% of currency in circulation and almost 40 million adults are without a bank account."
- #cite(<jeffbensonChinaReleasesDigital2022>, form: "prose") "use the e-CNY network to increase financial surveillance."
- democratize financial surveillance!
- Crypto tools allow you to look at any wallet already
- green transparency

=== From Payments to Investing
<from-payments-to-investing>
==== Personalized Investing
<personalized-investing>
- 2022 saw a wave of new platforms aiming to make investing easier for retail investors

- One example is Revolut, which expanded from a simple payments app to support varied saving and investment types @RevolutLaunchesETF2023 and @KickstartYourInvestment2023.

- Twitter (now X) is becoming a financial app.

- Inspiration from WeChat.

- Nerdwallet’s #cite(<tommytindallFinancialActionsSpeak2023>, form: "prose") suggests making financial commitments instead of resolutions.

- How can the mobile devices which the majority of us are carrying with us every day, help us make decisions about the businesses we engage with? In terms of user experience, can personalized AI advisors empower our financial actions from shopping to saving and investing?

== Saving Can be Conflated with Investing
<saving-can-be-conflated-with-investing>
There are two ways to look at sustainable savings and this chapter is going to look at both of them. 1) Savings in CO2e emissions 2) Savings in the financial sense of the word.

- Pension funds are some of the largest asset holders and choosing where to invest one’s pension can be a sustainable financial action.

- From building loyalty to building ownership, the first step is to start saving money to invest. How to encourage savings in daily life and make it a part of the everyday payments experience? Even starting with a small step, gathering a small target amount per month for savings, has the potential to shift the user’s way of thinking about money. The second step, choosing where to invest these savings, will help us begin thinking like an investor. To start noticing trends and looking into how finance shapes the world.

- The As Your Sow NGO aims to champion CSR through building coalitions of shareholders and taking legal action, including the Fossil Free Funds initative which researches and rates funds’ exposure to fossil fuels finance and its sister project Invest in Your Values rates retirement plans offered by employers (mostly US technology companiess) @asyousowFossilFreeFunds2024@asyousowHomeInvestYour2024

- #cite(<burkartClimateFinanceGets2022>, form: "prose")

- Savings and Investing are conflate into the same chapter because the large majority of savings that people have are invested by their banks. Thus the question of #emph[sustainable savings] comes one of where exactly are they invested and what is the impact of that investment of sustainability.

-

- Assumptions: — where to put money makes a difference to sustainability. i.e.~it matters what we buy, what we save, and where we invest

- Investing is a stronger signal to business than interactions on social media. Design Stakeholder capitalism. In future company every company should get a sustainability plan. this can be a push in that direction if companies with a sustainability plan become more competitive because of higher consumer demand.

- Hypothesis?

- Savings are the money one has in a pension fund or managed by themselves. For the majority of people, savings are invested by the bank and make up the largest proportion on investments for the people who are not active investors themselves.

- #cite(<M1FinanceReview2023>, form: "prose")

- "Environmental savings", "means the credit incurred by a community that invests in environmental protection now instead of paying more for corrective action in the future. If there is no way to estimate environmental savings for a particular project, then the amount of" #cite(label("yalecenterforenvironmentallaw&policyEnvironmentalPerformanceIndex2018")) and @YalePrincetonStanford[ p.33];.

- #cite(<ENVIRONMENTALSAVINGSDefinition>, form: "prose")

- Ethical Savings

- #cite(<EthicalSavingsEverything2023>, form: "prose")

- #cite(<EthicalShopping2019>, form: "prose")

- #cite(<GoodShoppingGuide>, form: "prose")

== Investing
<investing>
Young investors are typically #strong[#emph[retail investors];] investing small amounts of money for themselves. (Unless they work in an institution such as an investment firm, university endowment, pension fund or mutual fund, and have a say in where to invest large amounts of other peoples’ money.)

Retail investors face many challenges in comparison with their institutional counterparts. For instance, they may have much less time to do proper research, face information asymmetries, where finding good information is limited by time, ability, as well as financial literacy, whereas professional investors have the tools, skills, time, and knowledge, to make better investment decisions.

- Information evavõrdsus between pro and novice investors

- #cite(<openseaTopTaiwanInfluencers2022>, form: "prose") Taiwanese digital influencers as NFTs.

- #emph[For young people, investing mostly means buying cryptocurrencies?]

- Koreans investing in influencers? Koreans investing into media personalities: #cite(<yuqingzhao2021>, form: "prose")

- An open question is whether young investors are more easily than professionals swayed by #strong[#emph[influencers];];? Influencers are terrible for investing… but? Sustainable investing, kids watch TikTok #cite(<TikTokItImportantWe>, form: "prose")

  Influencer - crypto twitter connections

- There are many groups of Twitter, Reddit, and elsewhere, where investing trends start, causing more volatility

- Copy-investing is a popular feature of retail investing platforms like EToro

- #cite(<irenezhaoHereWhy0xIreneDao2022>, form: "prose")

- Investing is a fundamentally hopeful act. It means I think there’s a future. Specifically, 'green investing' is investing in the future of our planet - but can we trust the sustainability practices the 'green' investment vehicles aggregate, promising to have a positive impact? For example, the European Union for many years counted biomass as 'green' energy, even while forestry companies were cutting down trees to produce the biomass - the regulation was not specific enough to curb this practice. So, in effect, a 'green investor' might be supporting deforestation. How can an easy-to-use investment app address such complexities without alienating the users?

- The world will be very different in 30 years - it’s time to invest in services that make our societies resilient, able to robustly respond to rapid change. Research and product development go hand-in-hand; the outcome of this study can provide insights for new financial product and service development. Related to SDG 9: "Build resilient infrastructure, promote sustainable industrialization and foster innovation". The complexity of the situation offers an opportunity for design to make it understandable for humans

- In 2021 the Estonian government decided to free up mandatory retirement savings so people can exercise their own judgment on how to invest (or spend it). Financial analysts are worried the Estonian population will spend their retirement savings right away - instead of investing.

- #cite(<garygenslerWeHaveActive2022>, form: "prose") Investor protection, making investing accessible, climate risk disclosure

- #cite(<LetsDeFiDeFi>, form: "prose") Crypto DeFi education

- #cite(<MeetFintechsLeading2021>, form: "prose") #strong[#emph[Swedish green fintech (important article)];]

- #cite(<DoconomyAnnouncesLargest2021>, form: "prose") Doconomy Business footprint

==== Retain Investing in Financial Inclusion
<retain-investing-in-financial-inclusion>
Retail investing can be seen as a form of financial inclusion. Ant Group’s CEO Eric Jing says in #cite(<turrinCashlessChinaDigital2021>, form: "prose");: #emph["The financial system of the past 200 years was designed for the industrial era and served only 20% of the population and organizations. As we enter the digital age, we must better serve the remaining 80%".]

- #cite(<TAN202046>, form: "prose") proposes #emph["financial ecologies"] to understand the dynamic relationships between various actors: investors, advisors, government, where the government plays an active role in growing financial inclusion and responsible financial management. However, the paper further suggests that current robo-advisors (available in Singapore) make the investor captive to the agency of AI, making the person lose agency over their financial decisions.

- #cite(<liCanRetailInvestors2022>, form: "prose") suggests retail "investor attention can significantly improve enterprises’ green innovation level"

- Celo and Impact Market

- MicroLending

- Retail Investor Helpers: A wide number of banks are offering services marketed a sustainable. It’s hard to decide.

- #emph[Design implication];: #emph[As a user, I can use the app to compare banks available in my country]

- #cite(<rupertjonesGreenMoneyHow2022>, form: "prose")

- #cite(<jacksonEcoFriendlyGuideFinances2020>, form: "prose")

- #cite(<stefSustainableMoneyDesign2019>, form: "prose")

- #cite(<MakeMyMoney2023>, form: "prose")

- #cite(<seekingalphaBooksThatChanged2020>, form: "prose")

- #cite(<markoTeekondMiljoniliseInvesteerimisportfellini2022>, form: "prose")

- Consumer debt in the USA

- Nubanks, also known as challenger banks.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Company], [Link],),
    table.hline(),
    [SPARQAN], [],
    [Robinhood], [],
    [], [],
    [], [],
  )]
  , kind: table
  )

=== Increasing Number of Asset Classes
<increasing-number-of-asset-classes>
There are many asset classes only some of which would be accessible to a retail investor.

- The main categories of investment products are, based on the #cite(<InvestmentProductsInvestor>, form: "prose")

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    table.header([Investment Product],),
    table.hline(),
    [Stocks],
    [Bonds],
    [Mutual Funds],
    [ETFs],
    [Insurance Products such as Variable Annuities],
    [],
  )]
  , kind: table
  )

==== Thematic Capital
<thematic-capital>
- Build a thematic portfolio
- There’s a wide range of investment products marketed as #emph[sustainable];, however many of them are fake (#strong[CITATION];).

==== Green Bonds
<green-bonds>
- Sustainability Linked Bonds: What this?

- In 2017 the Malmö city in Sweden released green bonds to finance a sustainable transition of the city \[

- #cite(<anthropocenefixedincomeinstituteafiiAFIIAramcoReplacement2022>, form: "prose");: Aramco, Saudi Arabian public petroleum and natural gas company 'Fake green bonds' under scrutiny.

- #cite(<shashwatmohantyGreenPushGreenwash2022>, form: "prose");: "sustainable funds don’t buy Zomato’s ESG narrative"

- #cite(<priscilaazevedorochaGreenwashingEnters222022>, form: "prose");: "Sustainability-linked bonds let companies borrow cheaply if they meet environmental, social, and governance targets. A Bloomberg News analysis found those goals are weak"

- #cite(<priscilaazevedorochaGreenwashingEnters222022>, form: "prose") suggests "So far, most ESG investing is in the stock market. But the the \$22 trillion corporate bond market, where mature global companies such as Chanel go to borrow money from investors, has a particularly powerful role to play. Companies rely on debt much more than they do on stocks."

- Green Bonds ESG data needs to be visualized Passive Investing Why focus on PI instead of daily investing like Robinhood?

- 257 billion USD worth of green bonds issues annually in 2019, expected to reach 1 trillion usd by 2030 #cite(<macaskillThereGreenPremium2021>, form: "prose")

- China has the 2nd largest green bond market in the world; buyers are looking for green bond certification to reduce yield spread, meaning the price of the green bond is becoming more similar to the price of a 'regular' bond #cite(<liWhereGreenBond2022>, form: "prose")

- Chinese green bond market is growing fast #cite(<pengManagingFinancingCosts2022>, form: "prose")

=== Community Investing Enables Financial Inclusion
<community-investing-enables-financial-inclusion>
- Inexperienced investor can copy other people when investing.
- You don’t know how to invest? Build an investing community? Can follow others and raise capital together.
- Savings in CO#sub[2] Equivalent Emissions: CO#sub[2] savings are the amount of CO2e reduction one manages to achieve by changing one’s behavior and influencing others (people, companies). While the individual footprint is so small, the largest reduction will come from influencing large groups of people, either by leadership, role-model, or other means.
- In some ways community-investing competes with robo-advisors as communities can be led by professional investors and followed by less sophisticated investors. Investor communities can have the type of #strong[#emph[social proof];];, which robo-advisor do not possess.

==== Hedge Funds
<hedge-funds>
- While hedge funds used to be available for professional investors, #emph[smart contracts] make it possible to create decentralized organizations which pool member resources for investing.

- #cite(<nathanreiffDecentralizedAutonomousOrganization2023>, form: "prose")

- #cite(<ianbezekItTimeEveryone2021>, form: "prose")

- #cite(<blackrockESGInvestingHedge>, form: "prose") notes some ESG-oriented hedge funds can be "highly engaged with management teams" in order to influence management towards ESG practices in said companies”

- #cite(<ESGHedgeFunds2021>, form: "prose")

- #cite(<hedgeHedgeMakeHedge2023>, form: "prose");: Make a hedge fund with your friends

- Most successful investor invest together

- Angelist

==== DAOs
<daos>
Decentralized Autonomous Organizations (DAOs) which have an investable treasury may be compare to Hedge Funds as a collective form of investing. Because of the on-chain nature where transactions are visible to anyone, they may be seen as more transparent. Typically DAOs have a voting system to make decision while Hedge Funds may be more centrally controlled. Also, the legislation affecting each would be different as hedge funds are an older and more established financial tool whereas DAOs still fall in somewhat of a gray area.

- #cite(<TreesFuture2023>, form: "prose") DAOs to enable concerted action towards climate goals using the pooled resources in a treasury, a blockchain (on-chain), similar to how hedge funds work.

- #cite(<carrawuInvestingFriendsBenefits2021>, form: "prose") DAO consumer to investor

- #cite(<lucasmatneyVCbackedDAOStartups2022>, form: "prose")

- #cite(<blockchannelWhatDAOHow2017>, form: "prose")

- #cite(<InvestmentClubsCollectives>, form: "prose");: Crypto investment clubs canceled

- #cite(<IBISANetworkEnabling>, form: "prose");: Crypto crop insurance

- Social + NFTs - What would investing look like at the scale of 1 billion people

==== Green Investment Platforms
<green-investment-platforms>
There are many 'green investment platforms' who to trust?

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Name], [Description], [Link],),
    table.hline(),
    [Trine], [], [https:\/\/trine.com/],
    [The Many], [], [https:\/\/the-many.com],
    [Sugi], [], [https:\/\/sugi.earth/],
    [ClimateInvest], [], [https:\/\/clim8invest.com/],
    [Circa5000], [], [https:\/\/circa5000.com/],
    [FairOwn], [], [https:\/\/www.fairown.com/],
    [], [], [],
    [], [], [],
  )]
  , kind: table
  )

- #cite(<hankewitzEstonianFintechCompany2021>, form: "prose")

- Investing - Your investment fund’s ESG thesis investing thesis investing expert investing thesis research

- Investing thesis

- Open Banking: "Open Banking offers massive potential for improving online customer experience. That potential starts with the payment experience, which then generates a positive ripple effect through the entire customer journey.~" investing into good companies

=== Sustainable Investing is Based on Data
<sustainable-investing-is-based-on-data>
Sustainabile investing is firstly about changes in legislation which set stricter sustainability standards on companies. Secondly, increased transparency, new metrics, and new tools make it feasible to differentiate more sustainable companies from less sustainable ones.

==== Legislation
<legislation>
- #cite(<pwc2022GrowthOpportunity2020>, form: "prose") Changes to laws and regulations aimed at achieving climate change mitigation is a key driver behind the wave of ESG adoption. The goal of these laws, first adopted in the European Union, a self-proclaimed leader in eco-friendliness, is to pressure unsustainable companies to change towards greener practices, in fear of losing their access to future capital, and to create a mechanism forcing entire environmentally non-compliant business sectors to innovate towards sustainability unless they want to suffer from financial penalties. On the flip side of this stick and carrot fiscal strategy, ESG-compliant companies will have incentives to access to cheaper capital and larger investor demand from ESG-friendly investors.

- #cite(<houseofcommonsEnvironmentalAuditSecond2002>, form: "prose");: Already in 2001, the UK government was discussing ways to promote sustainable investment "fundamental changes in VAT or corporation taxes could be used to promote greener consumption and investment".

- #cite(<europeanparliamentDirective2014652014>, form: "prose") Directive 14 2014/65/EU, 2014: The European Union fully recognizes the changing financial landscape trending towards the democratization of investments: "more investors have become active in the financial markets and are offered an even more complex wide-ranging set of services and instruments".

- #cite(<kentonMiFIDII2020>, form: "prose");: Some key legislation for investors has been put in place recently, for example "MiFID II is a legislative framework instituted by the European Union (EU) to regulate financial markets in the bloc and improve protections for investors". #cite(<europeansecuritiesandmarketsauthorityMiFIDII2017>, form: "prose");: "MiFID II and MiFIR will ensure fairer, safer and more efficient markets and facilitate greater transparency for all participants".

- #cite(<quinsonTrumpPlanBlock2020>, form: "prose") While the larger trend is for governments to adapt to and work towards their environmental climate commitments and public demand, the sovereign risk remains an issue. For example, the policies supported by U.S. President Trump during his presidency ran counter to many sustainability recommendations, including those directed at the financial markets. Helping legacy industries stay competitive for longer through subsidies, and lack of regulation, or even regulation supporting legacy technologies.

There’s literature suggesting it’s possible to make investments that both make an attractive financial return and adhere to sustainability goals. In housing development, there’s evidence of 'green' buildings achieving a 'higher financial return than conventional buildings, both in terms of rent and sale price' (#cite(<oyedokunGreenPremiumDriver2017>, form: "prose");). There’s also a trend of investors looking for sustainability in addition to profits in a few countries.

- For example - In Sweden “Preferences for sustainable and responsible equity funds

- #cite(<lagerkvistPreferencesSustainableResponsible2020>, form: "prose") undertook a choice experiment with Swedish private investors.

- #cite(<smithChinaUltraElite2019>, form: "prose") suggests 74% of Chinese youth are looking for "positive impact".

- #cite(<lingeswaranLevellingShatteringMyths2019>, form: "prose") suggest philanthropy is on the rise in Asia however #cite(<hoAsianInvestorsAre2019>, form: "prose") counters investors are not sure how to separate sustainable assets from less sustainable ones.

==== Sustainable Finance
<sustainable-finance>
- Money connects all industries. People want to shop, save, invest sustainably - how to do it?

- #cite(<ChancellorSetsOut>, form: "prose") Taxonomy of sustainable activities in the UK

- #cite(<WorldEconomicOutlook2023>, form: "prose")

==== Regenerative Finance
<regenerative-finance>
- #cite(<WhatReFiRegenerative2023>, form: "prose");: What is Reggenerative Finance (ReFi).
- #cite(<regennetworkCommunityDevelopmentCall22>, form: "prose") and #cite(<regennetworkRegenNetworkInvest2023>, form: "prose") regen network
- #cite(<smithOneYearLater2021>, form: "prose")
- #cite(<KlimaDAO2023>, form: "prose") KlimaDAO
- #cite(<PlanetKlimatesLuis>, form: "prose") Moss.earth
- #cite(<SociallyResponsibleInvesting>, form: "prose")
- #cite(<naturalinvestMalaikaMaphalalaNatural2020>, form: "prose")
- #cite(<marquisRSFLeadingWay2021>, form: "prose")

=== Divesting
<divesting>
- In institutional finance, the Norwegian \$1.3T USD sovereign wealth fund (the world’s largest, followed by China)\[^5\] started a divestment trend in 2016 by divesting from coal. Their plan to reach net zero CO2e nonetheless only targets 2050. Furthermore, who would be the counterpart for such large transactions? The fund also announced divesting from Russia after its invasion of Ukraine, however has yet to sell any shares citing lack of buyers on the Moscow stock market. University of California also followed suit with divestment of its \$126B USD portfolio from oil and gas.

=== ESG Needs Standardisation
<esg-needs-standardisation>
- Environmental, Social, and Corporate Governance (ESG)

- Since the 1970s, international bodies, governments, and private corporations have developed sustainability measurement metrics, the prominent one being ESG (Environmental, Social, and Corporate Governance) developed by the UN in 2005. This rating system has already been implemented or is in the process of being adopted on stock markets all over the world and has implications beyond the stock markets, allowing analysts to measure companies’ performance on the triple bottom line: the financial, social, and environmental metrics.

- In Taiwan, the Taipei stock market has listed ESG stocks since 2017 and was hailed by Bloomberg as a regional leader in ESG reporting @grauerTaiwanLeadingWay2017, while Nasdaq Nordic introduced an ESG index in 2018, and Euronext, the largest stock market in Europe, introduced an ESG index and a series of derivative instruments in the summer of 2020 (#cite(<euronextEuronextLaunchesSuite2020>, form: "prose");).

- #cite(<doornStocksThatShould2020>, form: "prose");: Many ecologically focused funds with different approaches have been launched in recent years, with variations in asset mix and style of management. Thematic asset management is expected to grow, with investors packaging opportunities based on consumer trends.

- #cite(<kirakosianLOIMLaunchesCircular2020>, form: "prose") Digital payments and circular bio-economy, even using tactics such as co-branding with famous individuals.

- #cite(<jerseyeveningpostCharlesAchievingSustainable2020>, form: "prose") A recent example is one of the largest private banks in Switzerland, Lombard Odier & Co, when they launched a thematic bio-economy fund inspired by the words of The Prince of Wales, 'Building a sustainable future is, in fact, the growth story of our time'.

- #cite(<reidUniversityEdinburghGoes2020>, form: "prose") ESG gives banks a new tool to market and sell environmentally conscious opportunities to institutional investors, for example, universities - a case in point being the recent partnership between HSBC and the University of Edinburgh.

- #cite(<pwc2022GrowthOpportunity2020>, form: "prose") PWC suggests "asset managers educate their staff and client base. 'It will be critical to build stronger ESG expertise among their employees by up-skilling existing staff on ESG principles and strategically scout for and integrate more diverse and ESG-trained talent'".

- The advice consultancies are providing to banks establishes a common language and helps banks to sell strategical alignment for long-term institutional sustainability in terms of finance, social, and governance.

- For AI-powered assistants to be able to provide guidance, metrics are needed to evaluate sustainable assets, and ESG provides the current state-of-the-art for this. The largest obstacle to eco-friendly investing is greenwashing where companies and governments try to portray an asset as green when in reality it’s not. A personal investing assistant can provide an interface to focus on transparency, highlighting data sources and limitations, to help users feel in control of their investment decisions, and potentially even provide large-scale consumer feedback on negative practices back to the business through infringement discovery.

==== ESG Crisis
<esg-crisis>
- ESG companies don’t emit less CO2 than non-ESG companies.

- https:\/\/www.openesg.com/ because you can’t trust ESG @aikmanESGDAOOut2022 !

- ESG is filled with greenwashing

- ESG is a really low bad

- Sest ei saa ESG ja teisi mõõdikuid usaldada, crowdsourced mõõdikud

- Q: Reflection on the ESG wave: Does a company that performs well in carbon reduction but whose products are harmful to health conform to the spirit of ESG?

- Improving ESG Accessibility

- ESG risk

- Implication for design: ESG can’t trusted.

==== ESG Investing
<esg-investing>
- #cite(<margarytakirakosianMethodologiesAreAll2022>, form: "prose") suggests "Disparity between ESG methodologies was one of the key hurdles to finding the right sustainable strategy."

- Trading ESG futures?? because climate is slow it makes sense to trade de climate future

- CFI2Z4 tracks Carbon Emissions Futures @investing.comCarbonEmissionsFutures2024

- While ESG is riddled with problems, it has started a common language and there are many ways how to improve it

- Gov launching ESG funds. Why is this important to research now? People in their twenties should invest in their future. Millennials and younger generations like services with a green, eco-conscious focus.

- #cite(<ESGLangChaoFanSiYiJianJianTanBiaoXianYouYi2022>, form: "prose")

- Given our combined power (I’m a Millennial) with Generation Z, we are willing to pay more for sustainable products \[^8\].

- While promising to become sustainable, oil companies are increasing production #cite(<noorBigOilQuietly2023>, form: "prose");; Sunak, UK Primise Minister announced 100 news licenses for oil drilling in the UK.

- Other large university endowments, such as managed by Yale, Stanford and MIT are in decision gridlock\[^6\]. Blackrock, the largest private investment fund in the world with \$10T USD under management, released guidance reflecting their plans to shift their investments to vehicles that are measured on Environmental, Social, and Governance (ESG) performance \[^7\]. However they later backtracked from their decision.

- Banks are required by law to apply the principle of Know Your Customer (KYC).

- #strong[Feature:] How could people apply the same principle (#strong[Know Your Company];) when buying a product or investing? Would building an ESG community help push polluting companies towards greener practices? - or starving them from cheap access to capital.

- It can be as mundane as choosing the next eco-friendly product instead of the polluting one we purchase in the supermarket make a difference? How to invest in the growth of companies that put ESG at the center of their activities instead of using it for greenwashing? Creating direct ties will improve ESG. A journey from consumption to investing, in line with users’ personal values, by providing relevant sustainable finance guidance. x \#\#\#\# ESG Crisis

- #cite(<jamesphillippsESGCrisisJust2022>, form: "prose") and #cite(<FinancialMaterialityMarks2023>, form: "prose") ESG Not delivering on it’s hopes

- #cite(<tedxtalksDisruptiveNewModel2022>, form: "prose") large corporations are using ESG for greenwashing by investing in token-projects but not changing their fundamental polluting practices.

- #cite(<margarytakirakosianRedFlagsPrivate2022>, form: "prose")

- Banks are hiding emissions related to capital markets, which is a major financing source for oil and gas projects #cite(<wilkesExclusiveBanksVote2023>, form: "prose")

- #cite(<dailyHereOurList2021>, form: "prose") best ESG list

- ESG UAE FutureESGInvesting

- #cite(<sanjaibhagatInconvenientTruthESG2022>, form: "prose");: Not better environmental performance, ESG poor performance

- #cite(<simoes-coelhoBalancingGlobalCorporate2023>, form: "prose") Coca Cola ESG

- #cite(<pietrocecereItTotalMess2023>, form: "prose") calls ESG labeling confusing and arbitrary.

- ESG is a Marketing Tool

  - #cite(<gemmawoodwardGoodRiddanceESG2022>, form: "prose") 8 problems with ESG
  - #cite(<agnewRIPESG2022>, form: "prose") RIP ESG
  - #cite(<luoESGLiquidityStock2022>, form: "prose") found firms with a lower ESG score are more profitable.

- Analysis: Messari: investor education, information asymmetry

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Problems], [], [],),
    table.hline(),
    [ESG is an annual report not realtime], [], [],
    [], [], [],
    [], [], [],
  )]
  , kind: table
  )

==== How to Trace Worker’s Rights?
<how-to-trace-workers-rights>
- Another aspect of supply tracing is the treatment of workers and working conditions. Companies that intend to to give supply chain a voice” by connecting workers directly to the consumer (even in anonymously, to protect the workers from retribution), include #emph[CTMFile] and #emph[Alexandria];.
  - #cite(<WorkerVoice2022>, form: "prose") Worker Voice apps.
  - #cite(<timnicolleRealtimeESGData2021>, form: "prose") and #cite(<primadollarmediaPrimaDollarGivingSupply2021>, form: "prose") PrimaDollar Realtime ESG Give supply chain a voice by connecting workers directly to the consumer.
- #cite(<matthewgoreEmissionsRegulationsShipping2022>, form: "prose") reports the International Maritime Organization (IMO) targets cutting CO#sub[2] equivalent emissions in shipping 50% by 2050 compared to 2008.
- #cite(<sepandarkamvarSepKamvarCelo2022>, form: "prose") "A blockchain is a database without a database admin"
- #cite(<verraVerraReleasesRevised2023>, form: "prose") Verra new Methodology Announcement Webinar
- Eisenstein?: "Money is a technology".
- #cite(<eisensteinSacredEconomicsMoney2011>, form: "prose");: 5 things, UBI, demurrage, …
- #cite(<BlockchainCompaniesTeam2021>, form: "prose")
- #cite(<ganuWhyBlockchainCan2021>, form: "prose")
- Improve product #strong[#emph[provenance];];, blockchains offer this transparency

== Greenwashing Disturbs Sustainable Capital Allocation
<greenwashing-disturbs-sustainable-capital-allocation>
Greenwashing is one of the largest blockers of sustainability; humans will feel as if choosing green is useless and give up. Both the European Commission and the Chair of U.S. Securities and Exchange Commission (SEC) Gary Gensler have called for more legislation to curb business greenwashing practices. #emph["If it’s easy to tell if milk is fat-free by just looking at the nutrition label, it might be time to make it easier to tell if"green” or "sustainable" funds are really what they say they are.”] says Gensler @ussecuritiesandexchangecommissionOfficeHoursGary2022.

Upcoming EU greenwashing legislation hopes to curb misleading communications by companies. Until new legislation is in place (2030 in the EU), consumer awareness is crucial as currently most emission-reduction programs are voluntary and thus affected only by consumer demand @andreVoluntaryCarbonNeutral2022.

- Greenwashing is widespread in company social media communications @geoffreysupranThreeShadesGreen2022. ClimateBert AI finds rampant greenwashing @binglerCheapTalkCherryPicking2021@sahotaAIAnalysis8002021.

- For example #cite(<purkissBigCompostExperiment2022>, form: "prose") highlights the confusion between compostable and biodegradable plastics and public misunderstanding what happens to these plastics when they reach the landfill: "\[m\]ost plastics marketed as"home compostable” don’t actually work, with as much as 60% failing to disintegrate after six months”.

- #cite(<napperEnvironmentalDeteriorationBiodegradable2019>, form: "prose");: Shopping bags marketed as #emph[biodegradable] don’t show deterioration after 3 years in salt-water sea environment ..

- #cite(<chenxiyuHowAICan2021>, form: "prose") ESG is filled with greenwashing. #cite(<AntiESGCrusadeUS2023>, form: "prose") several US states are introducing regulation for ESGs to curb greenwashing. #cite(<francesschwartzkopffEUExploresTighter2022>, form: "prose") suggests the ESMA and EU has strengthened legislation to counter ESG greenwashing.

- Greenwashing is a large detractor from environmental action as it’s difficult to know what is sustainable and what is not.

- Green investing only makes sense if it’s possible to distinguish sustainable investments from not sustainable ones.

- #cite(<sahotaAIAnalysis8002021>, form: "prose");: "thanks to other emerging technology like IoT sensors (to collect ESG data) and blockchain (to track transactions), we have the infrastructure to collect more data, particularly for machine consumption. By measuring real-time energy usage, transportation routes, manufacturing waste, and so forth, we have more quantifiable ways to track corporations’ environmental performance without relying purely on what they say."

- #cite(<fredericsimonCommissionFireIncluding2020>, form: "prose") and #cite(<kirataylorEUPlanPuts2021>, form: "prose");: While the EU has proposed legislation to curb greenwashing, EU climate policy itself has been criticized for greenwashing. Sometimes greenwashing comes under legislative protection. #cite(<boothBurningCarbonSink2022>, form: "prose") describes how "A recent investigation shows illegal logging of protected areas in eastern European countries that supplies residential wood pellets in Italy. Belgium, Denmark, and the Netherlands are importing pellets from Estonia, where protected areas are logged for pellets and the country has lost its forest carbon sink, despite large-scale wood pellet plants being certified 'sustainable' by the Sustainable Biomass Program". A number of new AI-based tools aim to find instances of greenwashing.

- #cite(<ClimateBondsInitiative2022>, form: "prose");: Climate Bonds Initiative greening the \$55 trillion short-term debt market

- Marketing

  Sustainability Marketing

  - #cite(<ames15MostEnvironmentally2022>, form: "prose")

  - #cite(<themuseeditorsCompaniesMakingPlanet2020>, form: "prose")

  - #cite(<shradhabhattaTop10Companies2021>, form: "prose")

  - #cite(<earth.orgWorld50Most2022>, form: "prose")

  - #cite(<todd-ryanWhoAre100>, form: "prose")

==== Oracles for Sustainability Data
<oracles-for-sustainability-data>
Intersection with finance and Real World Data.

A data oracle is the concept of a source of real-world data which can be ingested through an application programming interface (API) to a blockchain system. There are many databases of sustainability information which could serve as an oracle for carbon labeling, packaging, transportation, consumption, and waste.

- #cite(<ethereumOracles2023>, form: "prose")

- #cite(<caldarelliOvercomingBlockchainOracle2020>, form: "prose") notes it’s a challenge to ensure the accuracy and trustworthiness of real-world data from Oracles.

- #cite(<bradydaleChainlinkFounderSays2021>, form: "prose") and #cite(<chainlinkNewReportBlockchains2022>, form: "prose");: The largest Oracle provider ChainLink founder Sergey Nazarov believes the collaboration of oracles and blockchains can make carbon credits more trustworthy.

- IPCI OpenLitterMap G.I.D Coin Regen Network

- #cite(label("dgen&positiveblockchainBlockchainSDGsHow2021"), form: "prose");: Positive Blockchain Database of blockchain for good projects

==== Realtime ESG
<realtime-esg>
There’s a growing number of companies helping businesses to measure CO2e emissions in their product lifecycle.

- #cite(<kylewiggersMakersiteLands18M2022>, form: "prose") proposes makersite, instant sustainability impact from supply chain.

- #cite(<makersiteImproveYourProduct>, form: "prose") proposes #strong[#emph[product sustainability modeling];];.

- #cite(<timnicolleRealtimeESGData2021>, form: "prose") "Real-time ESG data is more difficult to greenwash", "supply chain is a significant source of ESG content"

- Automate CO#sub[2] calculations realtime:

- #cite(<indrekkaldEestiITfirmaAutomatiseeris2022>, form: "prose");: FlowIT automate CO#sub[2] counting

- "Factory social score".

- People working at the factories can report conditions

- #cite(<ESGAnalyticsRealtime>, form: "prose");: "But the real breakthrough is how we can surface that real-time ESG data directly to individuals in the shops and online, linked to the products that they are browsing and potentially buying. This means that ESG change will finally be driven by the ultimate judge of business success – the customer."

==== Transparency
<transparency>
- #cite(<SimplyWallSt>, form: "prose");: Sites like Simply Wallstreet provide in-depth analysis: Simply Wallstreet also same for crypto

- Snowflake analysis like Simply Wallstreet

== Design Implications
<design-implications-4>
#figure(
  align(center)[#table(
    columns: (27.78%, 72.22%),
    align: (auto,auto,),
    table.header([Category], [Implication],),
    table.hline(),
    [], [#emph[As a consumer, I can get notified by the app about highlights of poor legislation refuted by science];.],
    [], [ESG alone is not a sufficient metric to prove sustainability of a company and needs to be accompanied by other metrics.],
    [], [#cite(<10YearsGreen2019>, form: "prose");: "Investors want to know where their money is going", says Heike Reichelt, Head of Investor Relations at World Bank.],
    [], [This applies to both institutional and increasingly retail investors. Sustainable investing is possible due to consumer demand for greener products and services, and new tools such as ESG for measuring sustainable businesses and assets, as well as advancements in large-scale computational technologies to analyze large amounts of tracking data, comparing performance between different assets. Given these developments, might it be possible to create a practical sustainable investing AI advisor for consumers?],
    [], [Sustainability is fragmented. How can billions of people find greener alternatives and build closer relationships with sustainability-focused companies? Greenwashing is widespread, how can we feel trust, honesty, and transparency? A research project for designing a sustainable shopping, savings, and investing companion.],
    [], [#strike[Reading EU Commission’s proposals, one might think the politicians have everything under control, we can relax and continue the same lifestyles as before. Unfortunately, this is not true. As with ESG, while the good intentions may be there, the reality is emissions keep rising, while they should be falling. It’s possible to curb greenwashing!];],
    [Greenwashing], [Laws against greenwashing],
    [], [Fintech Like a Robinhood stock symbol page for brands including live ESG metrics and ability to register divestment. Same for crypto can be automated? - People will start to discuss ESG vs price discrepancy?],
    [], [hetkel hinna info liigub aga toidu kvaliteedi info ei liigu roheline filter finding good wuality products stock are disconnected from the products companies make],
    [Accountability], [What if we gave consumers the tools to keep companies accountable?],
    [], [As an interaction design student who cares about the environment, I ask myself how can interaction design contribute to increase sustainability? I make the assumption that investing is inherently "good" for one’s life, in the same way, that doing sports is good, or eating healthy is good. It’s one of the human activities that is required for an improved quality of life as we age - and started investing sooner, rather than later, is best because of the compound interest. Nonetheless, investment also includes higher risk than sports or food. How to communicate the risk effectively while educating the users?],
    [], [Airbnb for Investments platform for projects linked to your consumption habits. Can provide better products for you as well as invest in these companies. The consumer can feel closer connection to the businesses they interact with through shared values, leads to participatory design and stakeholder capitalism. Platform to understand investment products. Green crowdfunding already allows people to invest into projects to make new green products, for example from recycled materials. but what about getting involved on a deeper level. Bigger than projects, scalable solutions. Kickstarter has green projects section. Startups vs large businesses. The design of the user interface helps the adoption of a new technology. What is the suitable user interface for millennial green investors?],
    [Community], [#strong[Feature];: Make a climate hedge fund with friends],
    [], [#strong[Feature];: Sustainable investing product for young people everyday use Crypto, NFT provide everyday excitement trend of young ppl in crypto retail investors without needing to pay bank fees],
    [], [#strong[Design:] #strong[Feature];: Help me write me investment thesis first.],
    [], [If corporate social responsibility (CSR) loyalty programs, driven by points systems are useful, can we go a step further, and create a pathway to enable the consumer to become an investor in the company they like to buy from? Could this strategy provide more meaning for the consumer, leading to higher customer retention, as well as financial returns?],
    [], [Where to invest for green impact? Which investment vehicles are the most suitable for green investments? When a person wants to make a sustainable investment, where to put your money if you want to make the world greener? If young people are worried about climate, why are they not investing in green assets? To what extent can interaction design increase market participants’ engagement with sustainability? What are some suitable user interfaces for millennial green investors? Is design relevant to investing decisions? Direct investment AI assistant vs marketplace of existing investment products? But how to measure? Currently, there is no easy way to do it, and the UX of traditional banks is too cumbersome and old-fashioned.],
    [], [My research aims to find ways to enable a wider audience to access sustainable investment opportunities. This chapter gives an overview of the current (as of late 2020) sustainable investing landscape as well as future trends related to interaction design and user experience innovations (fig.~4).],
    [], [This research is concerned with how billions of people might exclude polluting companies from their lives and elect to support companies that put sustainability in the core of their business instead. Why does it matter? Individual sacrifice is too small to have a meaningful impact. For societal change, we need to pool our resources.],
    [Accessibility], [#strong[How can ESG (environment, social, and governance) become accessible to our everyday experience, while avoiding greenwashing?];],
    [Loyalty], [Loyalty to investment. What are the standard conversations about money and savings that I would traditionally have with a financial advisor, that could be converted into a portable, mobile form, in my pocket every day?],
    [], [#strong[Feature:] We need a dashboard of comparable public indicators about each company.],
  )]
  , kind: table
  )

#horizontalrule

title: Methodology sidebar\_position: 4 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= Methodology
<methodology>
Start with expert survey, then expert interviews (because so many questions from literature review).

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Group], [Task], [],),
    table.hline(),
    [Experts (Finance)], [Short Survey], [],
    [Experts (Design)], [Short Survey], [],
    [Experts (Sustainability)], [Short Survey], [],
    [Target Audience (College Students)], [Long Survey], [],
  )]
  , kind: table
  )

I adopted a face-to-face method to increase response rates distributing flyers to students on college campuses, canteens, and classrooms getting verbal permission from educators in their ´ classrooms to distribute the survey flyer. The flyer included a colorful AI-generated visual with a futuristic game-link female figure, the title "climate anxiety survey", a website link (ziran.tw) and scannable QR-code.

Similarly to @liuDigitalCapabilityDigital2023 I distributed the survey in schools in the Northern, Soutern, Central, and East regions of Taiwan.

The survey only included questions and descriptions in Chinese. I have used the Claude 3 Opus model to translate them to english for this table.

#figure(
  align(center)[#table(
    columns: (47.22%, 52.78%),
    align: (auto,auto,),
    table.header([Original Question in Chinese], [English Translation],),
    table.hline(),
    [如果你/妳懷疑你/妳要買的番茄可能是由強迫勞工（現代奴隸）採摘的，你/妳仍然會買它嗎？], [If you suspect that the tomatoes you are going to buy may have been picked by forced labor (modern slaves), would you still buy them?],
    [你/妳關心食安嗎？], [Do you care about food safety?],
    [你/妳7年內買車嗎？🚘], [Will you buy a car within 7 years? 🚘],
    [你/妳7年內買房嗎？🏡], [Will you buy a house within 7 years? 🏡],
    [你/妳購物時知道產品環保嗎？], [Do you know if the products are environmentally friendly when you shop?],
    [你/妳覺得認證環保的公司更好嗎？], [Do you think companies certified as environmentally friendly are better?],
    [你/妳支持肉稅嗎？], [Do you support a meat tax?],
    [你/妳關心食用雞的生活嗎？], [Do you care about the lives of chickens raised for food?],
    [你/妳避免吃肉嗎？], [Do you avoid eating meat?],
    [你/妳覺得你/妳花錢會影響環境嗎？], [Do you think your spending affects the environment?],
    [你/妳會對金錢感到焦慮嗎？], [Do you feel anxious about money?],
    [你/妳會對金錢很節儉嗎？], [Are you very frugal with money?],
    [你/妳會經常存錢嗎？], [Do you often save money?],
    [你/妳對自己的財務知識滿意嗎？], [Are you satisfied with your financial knowledge?],
    [你/妳投資會考慮環保嗎？], [Do you consider environmental protection when investing?],
    [你/妳覺得台灣的經濟目標是增長嗎？], [Do you think Taiwan’s economic goal is growth?],
    [你/妳覺台灣的得環境退化是台灣的經濟增長的前提嗎？], [Do you think environmental degradation in Taiwan is a prerequisite for Taiwan’s economic growth?],
    [你/妳覺得台灣的經濟增長有助於保護環境嗎？], [Do you think Taiwan’s economic growth helps protect the environment?],
    [你/妳覺得經濟能不排CO2也增長嗎？], [Do you think the economy can grow without emitting CO2?],
    [你/妳覺得經濟增長有物質限制嗎？], [Do you think there are material limits to economic growth?],
    [你/妳會每天都用AI嗎？], [Do you use AI every day?],
    [你/妳會信任AI嗎？], [Do you trust AI?],
    [你/妳想要AI有個造型嗎？], [Do you want AI to have a specific appearance?],
    [你/妳喜歡待在大自然嗎？], [Do you like being in nature?],
    [你/妳擔心氣候變化嗎？], [Are you worried about climate change?],
    [你/妳對環境污染情況會感到焦慮嗎？], [Do you feel anxious about environmental pollution?],
    [你/妳知道許多植物和動物的名字嗎？], [Do you know the names of many plants and animals?],
    [你/妳感覺自己和大自然很接近嗎？], [Do you feel close to nature?],
    [你/妳努力實踐低碳生活嗎？], [Do you strive to live a low-carbon lifestyle?],
    [你/妳想做更多環保事嗎？], [Do you want to do more for environmental protection?],
    [你/妳對環境相關政治議題有興趣嗎？], [Are you interested in environmental political issues?],
    [你/妳信任碳排放抵消額度嗎？], [Do you trust carbon offset credits?],
    [你/妳的環保行動對環境保護有效果嗎？], [Do your environmental actions have an effect on environmental protection?],
    [你/妳想在行業內推環保嗎？], [Do you want to promote environmental protection within your industry?],
    [你/妳得自己對新觀念開放嗎？], [Are you open to new ideas?],
    [你/妳的大學對可環保性支持嗎？], [Does your university support environmental sustainability?],
  )]
  , caption: [36 Likert Fields included in the survey]
  , kind: table
  )

Respondents who remained outside the survey parameters were disregarded from the data analysis.

== Research Design
<research-design>
- #cite(<christianrohrerWhenUseWhich2022>, form: "prose");: Research methods

#strong[The research design of this study consists of 3 steps.]

- Qualitative research targeted at financial and interaction design experts, leading to a #emph[wish list] of features.
- Survey potential users’ preferences, including a choice experiment of the proposed features.
- Design a prototype of the personal sustainable finance AI assistant, tested using qualitative methods in a focus group.
- This mixed-method research design is divided into three stages (fig.~11).
- My purpose for the first qualitative stage is to explore the general themes arising from the literature review related to the design of AI advisors for investing. I will identify specific user experience factors, through interviewing experts in financial technology and user experience design and reviewing existing applications on the marketplace. At this stage in the research, the central concept being studied is defined generally as expectations towards a sustainable investment AI advisor.
- I will then proceed to the second, quantitative stage, informed by the previously identified factors, and prepare a survey, including a Likert scale, and a choice experiment, focusing on the preferences of the potential users aged 18-35, living in Sweden and Taiwan (see fig.~12 on next page), exploring the relationship between independent variables: - "Interest in Sustainability" - "Interest in Investing" - "Preferred Features" - and the dependent variable "User Sign-ups".
- In the third stage, I will return to the qualitative methods, by building a prototype of the sustainable investing AI companion, taking into account insights gathered in the previous stage. I will use a focus group to discuss the prototype, and conduct a thematic analysis of the discussions’ recordings, leading to further validation of previously gathered data and possible changes in the prototype. The gained insights, accompanied by the app prototype, which embodies my findings, will be the final outcome of my research.

== Conceptual Framework
<conceptual-framework>
- The conceptual framework map (fig.~13) presents the key concepts arising from the literature review thus far in the research process. I’m using these concepts when developing interview strategies for phase one of the research, developing the survey questionnaire for phase two, as well as for building the Personal Sustainable AI Financial Advisor (PSAA) for young adults at the final stage of the process. However, I expect the conceptual framework to further evolve with additional findings while conducting my research.

== Research Methods
<research-methods>
=== Phase One - Qualitative Research
<phase-one---qualitative-research>
The qualitative research methods employed in the first stage of the research design enables me to explore concepts arising for literature review further, using a more open approach, without limiting the conversation only to pre-ascribed notions. The strength of the qualitative approach in the first stage is to encourage the discovery of new ideas, not yet common in literature and potential user experience factors related to sustainable investing and user experience.

==== Sampling
<sampling>
My qualitative sampling structure uses non-probability snowball sampling, with the following criteria: financial industry, fintech, and design experts everywhere, including in Taiwan and Sweden, but also Estonia, Portugal, and elsewhere.

#strong[Method:] Semi-Structured Interviews

I will conduct exploratory research in English using semi-structured interviews recorded online and offline.

=== Phase Two - Quantitative Research
<phase-two---quantitative-research>
The strength of quantitative research is to enable me to access a larger sample of potential users in two countries, using online survey methods, and to validate some of the qualitative findings from stage one.

#strong[Sampling] My quantitative sampling structure uses a judgmental criterion: age 18-35, located in Sweden or Taiwan, surveyed using an English-language online survey.

#strong[Method:] Likert The survey includes a Likert scale between 1 to 7 to validate key findings from the first stage of the research by assessing responses to statements regarding the app’s design, features, and other criteria that may still emerge.

#strong[Method:] Choice Experiment The survey includes a choice experiment between different sets of potential features available when communicating with the sustainable finance AI companion.

=== Phase Three - Qualitative Research
<phase-three---qualitative-research>
In the last phase, I will return to the qualitative methods to further validate the quantitative findings from stage two. Here my focus will be on operationalizing the gathered insights into a prototype that users can experiment with and discuss with their peers in a focus group setting. Sampling

The phase three sampling structure uses a judgmental criterion: - age 18-35 - located in Taiwan - Using the English language for discussion

A focus group of 6 to 10 people will be gathered in Tainan. Because in-person presence is required in this stage, the prototype will only be tested by potential users physically present in Taiwan. To avoid convenience sampling, I will post online ads in English to invite people who I don’t know personally, to participate in a "financial AI application testing group" (wording may change).

#strong[Method:] Focus Group The strength of a focus group is the ability to observe potential users in a social setting, where knowledge can be exchanged between the participants. The whole experience, including emerging conversations, will be recorded and transcribed.

#strong[Method:] Thematic Analysis Finally, I will perform a thematic analysis of the focus group transcriptions in order to validate previous findings, and open avenues for future research.

#horizontalrule

title: Results sidebar\_position: 5 execute: echo: false editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= Results
<results>
== Expected Findings
<expected-findings>
- During the preparation of this research proposal, I conducted a preliminary round of face-to-face interviews using 21 open-ended probing questions using a convenience sampling of NCKU students on campus between ages 19 and 29, a total of 12 respondents. The interviews lasted between 9 and 21 minutes and were conducted to get some initial feedback on my research idea, the respondents’ daily routines, app usage, feelings towards financial questions, including investing, relationship with nature, and environmental sustainability. These preliminary conversations led me to emphasize more on the financial journey, i.e., to consider the importance of the shopping, savings, and payments apps students already use daily, which could serve as an entry point to becoming an investor. I expect my future research findings to confirm this initial idea and offer diverse ways and examples of what that path could look like in practice.

== Survey Overview / import from Ziran
<survey-overview-import-from-ziran>
A survey of Taiwanese college students (excludes overseas Chinese-speaking students as well as foreign students) covering attitudes towards shopping, saving, investing, economy, nature, sustainability, and AI.

Survey Oct.~13th - Nov.~3rd, 2023

2000 cards with a QR code printed out

Distribution conducted at 8 universities (handing out the cards)

1289 people started the survey, 518 quit

771 people completed the whole survey

Data after filtering: 675 people aged 18-26 (Gen-Z), Taiwanese, current students in BA (large majority), MA (small minority) or PhD level (very few respondents)

36 likert fields (5-point scale) used for clustering the students into 3 personas with K-means clustering

14 product features (multiple-choice) used for K-modes clustering

4 choice experiments

2 option ranking questions

10 text fields used to enrich the personas

= Old
<old>
== Findings
<findings>
- Literature: AI assistants should integrate with Digital Product Passports
- Literature: AI assistants should show carbon label data.
- Literature: AI assistants should avoid taking ESG at face value (because it’s a really low bar) and integrate other metrics such as B Corp.
- Literature: AI assistants should
- Literature: Do not make another investing app, make a sustainability filter for excisting investing platforms.
- Literature: College students can support extended producer responsibility

=== RQ 1
<rq-1>
#strong[How might AI assistants empower regenerative shopping, saving, and investing?]

Display the ESG, EPR, B-Corp, etc, etc credentials for each product and investment.

EPR and B-Corp are success stories which shoul be highlighted while ESG is largely discredited.

There are many existing and ongoing approaches to sustainability. The best approach might be to plug into excisting system and communities and legislation to support and empower them.

=== RQ 2
<rq-2>
#strong[How might one design an intuitive sustainable shopping, saving, investing app?]

Apple Watch app

=== RQ 3
<rq-3>
#strong[What app features might college students rate as the highest priority?]

Autopilot

=== RQ 4
<rq-4>
#strong[How might one visualize ecological impact in digital product design?]

Accuracy is more imprttant for hhuman trust tthan actual impact

== Ideas for Interfaces
<ideas-for-interfaces>
Show all the different prototypes just likes architects do. And then defent why I chose the one I did.

For NW make a Loom with the interfaces and talk about them?

#horizontalrule

title: Shopping sidebar\_position: 2 execute: echo: false editor: render-on-save: false suppress-bibliography: true

#horizontalrule

== Shopping
<shopping-1>
=== Boycott Count (Overall)
<boycott-count-overall>
#box(image("_thesis_files/figure-typst/cell-6-output-1.svg"))

=== Why Boycott
<why-boycott>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header(table.cell(align: right)[], table.cell(align: right)[Reason], table.cell(align: right)[Count],),
    table.hline(),
    table.cell(align: horizon)[0], [食安問題], [33],
    table.cell(align: horizon)[1], [地溝油], [10],
    table.cell(align: horizon)[2], [黑心油], [8],
    table.cell(align: horizon)[3], [食安], [5],
    table.cell(align: horizon)[4], [政治因素], [4],
    table.cell(align: horizon)[...], [...], [...],
    table.cell(align: horizon)[182], [因為有出新聞], [1],
    table.cell(align: horizon)[183], [此公司危害食安，以抵制這種行為讓公司更能意識到執行此行為的後果], [1],
    table.cell(align: horizon)[184], [地溝油啊], [1],
    table.cell(align: horizon)[185], [不認同理念], [1],
    table.cell(align: horizon)[186], [因為這家公司壓榨員工], [1],
  )]
  , kind: table
  )

=== Trusted Brands
<trusted-brands>
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header(table.cell(align: right)[], table.cell(align: right)[Brand], table.cell(align: right)[Count],),
    table.hline(),
    table.cell(align: horizon)[193], [No trusted brand], [329],
    table.cell(align: horizon)[194], [Have but not specified], [56],
    table.cell(align: horizon)[0], [義美], [42],
    table.cell(align: horizon)[1], [Apple], [9],
    table.cell(align: horizon)[2], [光泉], [7],
    table.cell(align: horizon)[...], [...], [...],
    table.cell(align: horizon)[83], [自家種植], [1],
    table.cell(align: horizon)[84], [Casetify], [1],
    table.cell(align: horizon)[85], [Adidas], [1],
    table.cell(align: horizon)[86], [麥當勞], [1],
    table.cell(align: horizon)[97], [淨毒五郎], [1],
  )]
  , kind: table
  )

The following responses were counted as "no brand": "無", "沒有", "沒有特別", "🈚️", "目前沒有", "No", "沒", "沒有特別關注", "沒有特別信任的", "不知道", "無特別選擇", "目前沒有完全信任的", "沒有特定的", "沒有特定", "沒有特別研究", "目前沒有特別關注的品牌","N", "none", "無特別", "目前無", "沒有特別想到", "沒有固定的", "x", "沒在買", "nope", "一時想不到…", "沒有特別注意", "無特別的品牌", "無絕對信任的品牌", "不確定你說的範圍", "還沒有"

== Choice Experiments
<choice-experiments>
#box(image("_thesis_files/figure-typst/cell-9-output-1.svg"))

#horizontalrule

title: Attitudes sidebar\_position: 3 execute: echo: false editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= College Student Attitudes (Overall)
<college-student-attitudes-overall>
These are student attitudes across all 36 likert fields without clustering. Clustered results are available under the Personas section.

== Shopping
<shopping-2>
#box(image("_thesis_files/figure-typst/cell-11-output-1.svg"))

== Saving and Investing
<saving-and-investing>
#box(image("_thesis_files/figure-typst/cell-12-output-1.svg"))

== Economy
<economy>
#box(image("_thesis_files/figure-typst/cell-13-output-1.svg"))

== AI Usage
<ai-usage>
#box(image("_thesis_files/figure-typst/cell-14-output-1.svg"))

== Nature
<nature>
#box(image("_thesis_files/figure-typst/cell-15-output-1.svg"))

== Environmental Protection
<environmental-protection>
#box(image("_thesis_files/figure-typst/cell-16-output-1.svg"))

== Learning Environment
<learning-environment>
#box(image("_thesis_files/figure-typst/cell-17-output-1.svg"))

== Correlations Between Fields
<correlations-between-fields>
#box(image("_thesis_files/figure-typst/cell-18-output-1.svg"))

== Environmental Knowledge Ranking Experiment
<environmental-knowledge-ranking-experiment>
Test knowledge about the environment.

#box(image("_thesis_files/figure-typst/cell-19-output-1.svg"))

#horizontalrule

title: Investing sidebar\_position: 3 execute: echo: false editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= Investing
<investing-1>
Student attitudes towards investing.

=== Investing Experience (Overall)
<investing-experience-overall>
#box(image("_thesis_files/figure-typst/cell-21-output-1.svg"))

== Choice Experiment
<choice-experiment>
Question: 你/妳選哪個投資？Which investment do you choose?

#box(image("_thesis_files/figure-typst/cell-22-output-1.svg"))

#horizontalrule

title: Personas sidebar\_position: 3 execute: echo: false editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= Personas
<personas>
== Clustering Students to Build 3 Personas
<clustering-students-to-build-3-personas>
Personas are created using K-means clustering, an unsupervised machine learning algorithm, which clusters college students based on their responses across 36 Likert-scale fields in the online survey. Clusters are visualized using Principal Component Analysis (PCA), where the principal component loadings on the X and Y axes represent the weights of the original Likert-scale fields, transformed into the principal components that capture the most variance.

- There is some similarity between clusters. All 3 personas report a high level of financial anxiety and below-average satisfaction with their financial literacy.

- Principal Component Analysis (PCA) is used to convert data to lower dimension space. This is a predecessor of embeddings.

#box(image("_thesis_files/figure-typst/cell-24-output-1.svg"))

=== Persona 1: "Eco-Friendly"
<persona-1-eco-friendly>
Questions Most Affecting Persona Creation include…

#box(image("_thesis_files/figure-typst/cell-25-output-1.svg"))

#block[
#box(image("_thesis_files/figure-typst/cell-25-output-2.svg"))

]
#block[
#box(image("_thesis_files/figure-typst/cell-25-output-3.svg"))

]
#block[
#box(image("_thesis_files/figure-typst/cell-25-output-4.svg"))

]
=== Persona 2: "Moderate"
<persona-2-moderate>
Questions Most Affecting Persona Creation include…

#box(image("_thesis_files/figure-typst/cell-26-output-1.svg"))

#block[
#box(image("_thesis_files/figure-typst/cell-26-output-2.svg"))

]
#block[
#box(image("_thesis_files/figure-typst/cell-26-output-3.svg"))

]
#block[
#box(image("_thesis_files/figure-typst/cell-26-output-4.svg"))

]
=== Persona 3: "Frugal"
<persona-3-frugal>
Questions Most Affecting Persona Creation include…

#box(image("_thesis_files/figure-typst/cell-27-output-1.svg"))

#block[
#box(image("_thesis_files/figure-typst/cell-27-output-2.svg"))

]
#block[
#box(image("_thesis_files/figure-typst/cell-27-output-3.svg"))

]
#block[
#box(image("_thesis_files/figure-typst/cell-27-output-4.svg"))

]
== Clustering Heatmap
<clustering-heatmap>
#box(image("_thesis_files/figure-typst/cell-28-output-1.svg"))

== Mean Answer Scores
<mean-answer-scores>
Mean response values for each Likert question in each cluster:

#figure(
  align(center)[#table(
    columns: 22,
    align: (auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,auto,),
    table.header(table.cell(align: right)[], table.cell(align: right)[Cluster], table.cell(align: right)[如果你/妳懷疑你/妳要買的番茄可能是由強迫勞工（現代奴隸）採摘的，你/妳仍然會買它嗎？], table.cell(align: right)[你/妳關心食安嗎？], table.cell(align: right)[你/妳7年內買車嗎？🚘], table.cell(align: right)[你/妳7年內買房嗎？🏡], table.cell(align: right)[你/妳購物時知道產品環保嗎？], table.cell(align: right)[你/妳覺得認證環保的公司更好嗎？], table.cell(align: right)[你/妳支持肉稅嗎？], table.cell(align: right)[你/妳關心食用雞的生活嗎？], table.cell(align: right)[你/妳避免吃肉嗎？], table.cell(align: right)[...], table.cell(align: right)[你/妳知道許多植物和動物的名字嗎？], table.cell(align: right)[你/妳感覺自己和大自然很接近嗎？], table.cell(align: right)[你/妳努力實踐低碳生活嗎？], table.cell(align: right)[你/妳想做更多環保事嗎？], table.cell(align: right)[你/妳對環境相關政治議題有興趣嗎？], table.cell(align: right)[你/妳信任碳排放抵消額度嗎？], table.cell(align: right)[你/妳的環保行動對環境保護有效果嗎？], table.cell(align: right)[你/妳想在行業內推環保嗎？], table.cell(align: right)[你/妳得自己對新觀念開放嗎？], table.cell(align: right)[你/妳的大學對可環保性支持嗎？],),
    table.hline(),
    table.cell(align: horizon)[0], [0], [2.026906], [3.991031], [2.206278], [1.663677], [3.681614], [4.300448], [3.434978], [3.533632], [2.269058], [...], [3.381166], [3.457399], [3.426009], [4.264574], [3.820628], [3.210762], [3.645740], [3.730942], [4.403587], [4.210762],
    table.cell(align: horizon)[1], [1], [2.106742], [3.516854], [3.898876], [2.904494], [3.140449], [4.028090], [2.943820], [3.117978], [1.685393], [...], [2.814607], [3.039326], [2.808989], [3.679775], [3.101124], [2.865169], [3.202247], [3.117978], [4.016854], [3.719101],
    table.cell(align: horizon)[2], [2], [2.214286], [3.225000], [1.575000], [1.282143], [2.853571], [3.864286], [2.642857], [2.610714], [1.600000], [...], [2.453571], [2.521429], [2.446429], [3.364286], [2.739286], [2.664286], [2.792857], [2.878571], [3.850000], [3.500000],
  )]
  , kind: table
  )

== Agreement between personas
<agreement-between-personas>
Highest agreement between personas is about health, safety, pollution and climate concerns.

#box(image("_thesis_files/figure-typst/cell-30-output-1.svg"))

#horizontalrule

title: Features (AI) sidebar\_position: 7 execute: echo: false editor: render-on-save: false suppress-bibliography: true

#horizontalrule

== AI Companion
<ai-companion>
=== Likert-Based Clustering
<likert-based-clustering>
AI-assistant feature choices per Likert-based Personas

#box(image("_thesis_files/figure-typst/cell-32-output-1.svg"))

Want: - Product origin - Product materials - Product packaging

Don’t Want: - News - Carbon tracking - Eco-friends - …

== Feature-Based Clustering
<feature-based-clustering>
Clustering students based on AI-assistant feature choices.

Want: - Product origin - Product materials - Product packaging - Eco services

=== Feature Preferences (Overall)
<feature-preferences-overall>
#box(image("_thesis_files/figure-typst/cell-33-output-1.svg"))

== Feature Preferences (By Cluster)
<feature-preferences-by-cluster>
#box(image("_thesis_files/figure-typst/cell-34-output-1.svg"))

== Preferred AI Roles (Overall)
<preferred-ai-roles-overall>
#box(image("_thesis_files/figure-typst/cell-35-output-1.svg"))

#horizontalrule

title: Experts sidebar\_position: 7 execute: echo: false editor: render-on-save: false suppress-bibliography: true

#horizontalrule

== Experts
<experts>
Analysis of recorded conversation

#horizontalrule

title: Discussion sidebar\_position: 6 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= Discussion
<discussion>
College Student Willingness to pay ( WTP)

Defining the Problem Space.

== Data Analysis
<data-analysis>
- Use K-Means clustering for survey data
- K-means clustering is similar to vector distances for similarity used in large-language models (LLMs) word embeddings and deep learning.

== Mindmaps
<mindmaps>
Initial version of the concept map focused on the app itself.

Current concept map focusing on sustainability.

== Factorial Surveys
<factorial-surveys>
- #cite(<li2022assessing>, form: "prose");: "Factorial surveys is a research method that combines classical experiments with survey methodologies. Factorial surveys use short narratives, called vignettes, to represent various levels of independent variables that are too complex or unethical to create and manipulate in real-world or lab situations"

== What is Research?
<what-is-research>
== Research Through Design
<research-through-design>
- Design research books
- #cite(<koskinenDesignResearchPractice2011>, form: "prose")
- #cite(<riesLeanStartupHow2011>, form: "prose")
- Design Studies Journal

#emph[Research through design] is a method for interaction design research in Human-Computer Interaction (HCI).

- #cite(<zimmermanResearchDesignMethod2007>, form: "prose")

- #cite(<salovaaraHowDefineResearch2020>, form: "prose") defining a research question

- #cite(<nunnallyUXResearchPractical2016>, form: "prose")

interview people at google who made the green filter options

- Design artefacts

- "design’s nature as a 'problem-solving' science" #cite(<oulasvirtaHCIResearchProblemSolving2016>, form: "prose")

- my contribution is the design artefact, "HCI researchers also make constructive contributions by developing new technologies and design"

- #cite(<affairsCardSorting2013>, form: "prose") Card sorting

- #cite(<HowModelsWork>, form: "prose")

- Behavirour kit:

Take the metrics from the several frameworks and display them on the product and company level? People can choose their own framework and see product data through that lens and vocabularies.

#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,auto,),
    table.header([Col1], [Col2], [Col3],),
    table.hline(),
    [Donut Economy], [Unrolled Donut], [],
    [Regenerative Capitalism], [8 Principles], [],
    [Blue Economy], [], [],
    [ESG], [], [],
    [B Corp], [], [],
  )]
  , kind: table
  )

- "research for design". design research is about expanding opportunities and exploration

- #cite(<ranywayzResearchDesign2016>, form: "prose")

- #cite(<mehmetaydinbaytasKindsDesignResearch2020>, form: "prose")

- #cite(<047WordCreative>, form: "prose")

- #cite(<KindsDesignResearch>, form: "prose")

- #cite(<QualitativeVsQuantitative>, form: "prose")

- #cite(<WhenUseWhich>, form: "prose")

- #cite(<GreatUXResearch>, form: "prose")

- #cite(<erikahallDesignResearchDone>, form: "prose")

- Contact Kalle Lasn, Culture Jam

- online/offline ethnographic participant observation At this stage in the research, the central concept being studied is defined generally as user expectations for a sustainable investment app.

- What are my hypotheses?

- User experiments

- Financial statistics

- Analyzing existing apps and user pain-points

- List of topics gleaned from literature review for discussion with the experts:

- Transparency and sources of ESG and similar data

- I will test the prototype with potential users using an online choice experiment survey.

- Research Process In terms of literature review, academic inquiry in social sciences largely follows phenomena, while the issues and technologies discussed here are emergent. Not many studies exist yet (they might in a few years), which is why some of my references are to company press releases and news stories, or for public companies, their advisory for investors.

- Target potential retail investors aged 20-29, all genders, in countries with highly developed financial markets and active social campaigns demanding sustainability (Sweden). And Taiwan. In general, the Taiwanese culture is savings oriented: I’m in a good location for financial user experience research.

- Set your target goals

- Access to health care

- Access to education

- Climate action

I propose #emph[interfaces] and #emph[workflows] to see financial interactions through the filter of sustainability.

What kind of sustainability info do college students care about? How would college students prefer to interact with the AI? What role would college students prefer the AI to take? How can college students trust AI? What can college students do to aid sustainability efforts? How might AI assistants help college students find shopping, saving, and investing opportunities?

"Systemic change through financial actions driving policy and market changes encourage broader industry shifts towards greener practices".

Overconsumption-driven extractive business practices contribute to the degradation of Earth’s natural ecosystems, pollution of water, air, and soil, deforestation, diminishing biodiversity, climate instability, extreme weather, modern slavery, worsening human health, and other environmental and social challenges (ADD CITATION). Companies are attuned to consumer demand however widespread greenwashing makes it tiring to find sustainability-focused companies and requires extensive time for research. Even for highly motivated people, it’s difficult to know what’s sustainable.

My interest lies in understanding how AI assistants can help conscious consumers become sustainable investors. The purpose of this study is to explore how to provide the best user experience to potential sustainable financial AI companion users. In their sustainability report every company looks perfect. How can people shop, save and invest sustainably? Where does our money go and what are some greener alternatives? The companion enables people to be more transparent and responsible in their consumption behavior.

in taiwan water is too pollutee can’t swim

air is too dirty can’t breather (show my own stats)

start local then go global with backup data from global sources

ask chatgpt how to organize my sections

rq: how to connect env destruction pollution to source causes

rq: how to connect everyday financial actions to environmental impact in a visual/ meaningful way

idea came riding my bike in annan can’t swim in yhe annan river

show local pollution map?

show factories on the map

instead of the browser pluging just make a website where you can share the link of the product (and cache rhe results)

on ios can use the share screen to share to the app?

ICID calls upon us to have the courage to redesign entire industries

This research takes place at the intersection of Taiwanese college students, sustainability, finance, AI, and design.

For the average person like myself, my experience with money is mostly limited to buying things at the supermarket. Food, clothes, furniture, soap, mobile phone. This leaves very few options on how to start with something new like saving and investing.

Could the Green Supermarket become the entry point to Green Savings and Green Investing?

Oboarding more people for sustainable practices is a complex interaction design issue hindered by ambiguous data (what is sustainable?) and messy human motivations (we love buying things).

What can people who want to preserve Earth’s environment, exactly do? How can networks of people come together?

— LLMs enable data journalists to create stories: #cite(<biglocalnewsExpertShareSimon2024>, form: "prose")

Health tracking apps paired with connected devices such as Apple Watch filled with sensors provide one model for simple interactions to dynamically track digital health data - also known as a quantified self. This data allows apps to provide tips how to improve health outcomes through small daily actions such as climbing more stairs. Small interactions allow users to align their goals with their actions.

What would be a good interface to track sustainability? What is the user interface at scale, useful for billions of people?

One way to influence societal outcomes is to decide where to put our money. While our financial decisions are a vote towards the type of businesses we want to support, is it enough?

While some people are demanding sustainability, and some governments and companies are announcing green investment opportunities, how can consumers discover the most suitable investment options for their situation?

How can retail investors access and differentiate between eco-friendly sustainability-focused investable assets?

The level of knowledge of and exposure to investing varies widely between countries and people.

Could linking green consumption patterns with sustainable investing provide another pathway to speed up achieving climate justice as well as personal financial goals?

In this simplified scenario, I’m in a physical offline store, doing some shopping. When putting a bottle of Coca Cola in my basket, my AI companion Susan will ask me a personalized question:

Does individual climate action help?

Gen-Z college students (target users) may not have the capital to make a financial dent today however they can be early adopter and they will be the decision-makers in a few years.

"Like climate change, the focus on individual actions as a solution is often misplaced, though it remains a focus of media and industry. For decades, the petrochemical industry has offloaded responsibility onto individuals through promoting concepts such as the"carbon footprint”, championed in a 2004 advertising campaign by British Petroleum” @cherryProfitRethinkingCorporate2010[ in #cite(<laversFarDistractionPlastic2022>, form: "prose");];.

Individual efforts are too small to matter unless they’re inspired by Community a effort

atmospheric pollution and climate change

The latest IPCC report #cite(<calvinIPCC2023Climate2023>, form: "prose")

#cite(<dimockDefiningGenerationsWhere2019>, form: "prose")

- kora 95% https:\/\/kora.app/

- Earn KORA coins for reducing CO2 emissions

I, as the researcher, am similar to the blind people in the elephant story; focusing on greening shopping, saving, and investing are only the trunk of the enormous elephant that is environmental disaster unfolding in front of our eyes.

== Results
<results-1>
The research helps me (and others) to

- avoid reinventing the wheel and duplicating existing approaches.

- It aims to help app developers maximize impact by aiding complementary additionality.

- Make high-quality products. If used wisely, money can help build communities of sustainable impact.

==== Define Words
<define-words>
Define every word in the title: "The Journey from Consumer to Investor: Designing a Financial AI Companion for Young Adults to Help with Sustainable Shopping, Savings, and Investing"

- Journey - behavioral change takes time
- Consumer - purchase goods without thinking about the effect
- Investor - thinking about the return
- Design - decisions
- Financial - dealing with money
- AI Companion - automated sidekick
- Young Adults - College Students
- Help - to be of assistance
- Sustainable Shopping - shopping understanding the consequences
- Sustainable Saving - in this context I mean Sustainable Savings, that is reducing one’s environmental footprint
- Sustainable Investing - activity of thinking longer-term

=== Open-ended Questions
<open-ended-questions>

=== Close-ended Questions
<close-ended-questions>

== Expert Surveys
<expert-surveys>

== Database
<database>
Compile a database on relevant apps and companies in the space

Easily access data used in this research project (please wait a bit until it loads below). The database includes sustainability-focused apps categorized by features and problems they try to solve, sustainable investing apps, and links to research papers.

== User Survey
<user-survey>
and a including a choice experiment between potential feature sets in consumption, savings, and investment.

Start with a simple but powerful question: — Does it matter what you buy? — Does it matter how much you save? — Does it matter where you invest? Why?

== Research Limitations
<research-limitations>
- This work is focused on user experience design and does attempt to make a contribution to economics. Sacred Economics is use as-is as a framework and visualization tool.

- First, finance is a highly regulated industry and the proposed user experience designs may be limited by legal requirements. This study does not take such limitations into account, rather focusing only on the user experience.

- Finally, ESG needs data to give us an accurate understanding of the realities inside companies and the user experience design does not address the underlying data quality problem further than by providing a link to the data source.

- Research Reason: While many people are working on AI models, there’s a lack of people working on "Human-AI interaction". Sustainability is the context. How can we better team up to solve the challenges we face this century? The huge externalities.

- I don’t have access to user financial data.

- ESG data is expensive so couldn’t be used in this research.

== Future Research
<future-research>
The literature is rich and there is ample space for future research. The following includes some suggestions for authors whose work deserves a deeper look.

- Does the specialized interface offer any advantages of a general UI such as ChatGPT, Claude, Gemini, Mistral, and others?

#horizontalrule

title: Prototypes sidebar\_position: 7 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

== Prototypes of Product Features
<prototypes-of-product-features>
I developed a number of early prototypes to visualize product feature ideas.

What’s on the intersection of College Students, Sustainability, Investing, Data-Driven Design and Artificial Intelligence (AI)? AI-Driven Sustainable Investment Tools.

The app aims to address the market failure by providing consumers sufficient sustainability information on the goods, services and investments.

resource depletion

and adopt the doughnut economy as my overarching theoretical framework

Humans are successful because of our adaptability. The study suggests tools to adapt to our current reality.

United Nations Decade on Ecosystem Restoration

Hypothesis: extractive business practices reduce college students trust, regenerative business practices create trust among college students towards the company.

Provided there is awareness

How can sustainability-minded college students find companies that meet their expectations, standards and requirements?

- Make a public profile of my carbon consumption!!! Like on Commons.

- Shop

- Save

- Invest

- Build closer relationships with sustainability-focused companies

- Sales funnel for eco-focused products

- The eco-friendly market is fragmented

- Build trust, clarity, transparency, and honesty

- Make a 'Sustainability Flywheel' graphic, like that of Amazon’s

- Sustainability is fragmented. How can billions of people build closer relationships with sustainability-focused companies based on honesty and transparency? A research project for designing a sustainable shopping, savings, and investing companion.

- Most sustainability plans rely on carbon credits to achieve their goals, making carbon credits a single point of failure. If the credits are not accurate, the whole system collapses.

- TODO: Make a table showing research results translated to design decisions

- Your Green Helper

- Make some initial prototype? make YoutTbe video… hi, you have reached? spread… through ESTBan and others?

- Currently CO#sub[2] footprint calculators ask you a couple of questions and give a ballpark estimate. Does it make sense to track sustainability on a more nuanced level, like Apple Health, in order to encourage sustainable behavior?

#figure(
  align(center)[#table(
    columns: (24.66%, 24.66%, 24.66%, 26.03%),
    align: (auto,auto,auto,auto,),
    table.header([Product Idea], [Source], [], [Prototype Link],),
    table.hline(),
    [Speak Truth to Power], [Literature Review], [Consolidate user feedback for companies], [greenfilter.app/prototypes/truth-power],
    [Shopping Divest], [Literature Review], [What if you could build communities based on what you buy?], [greenfilter.app/prototypes/shopping-divest],
    [True Cost], [Literature Review], [What if you could see the actual cost of each product including externalities?], [greenfilter.app/prototypes/true-cost-],
    [Sunday Market], [Literature Review], [First prototype for going to the organic Sunday Market with friends.], [],
    [XYZ], [Expert Interview], [], [],
    [ABC], [User Survey], [], [],
  )]
  , kind: table
  )

== Affinity Diagrams
<affinity-diagrams>
- Affinity diagrams help users organize ideas by brainstorming, sorting and labeling to cluster related information @karaperniceAffinityDiagrammingCollaboratively2018@quignardUXAnalysisPhase2022

Scan a product to see the company and start investing or divesting from them Current economics is lowering the quality of life on the planet

Actionable Insights: Translate data into everyday actions the app can suggest.

- What does investing look like at the scale of billions of people? like IG
- The most effective things are Commodities? Food, transport, fashion, plant trees.
- personalized AI, meta glasses understand your context. sense and reconstruct the world around you and to understand the context in which you’re using your device.sense and reconstruct the world around you and to understand the context in which you’re using your device. Make suggestions and take action proactively to help you get things done — ideally, so seamlessly that you may not even notice.neuroscience co-adaptation of the interface. your future devices will learn and adapt to you as you use them.
- Scalable Climate Solutions: What really works on a large scale?
- brand colors: pink, orange, green

== Shopping-as-Investing
<shopping-as-investing>
- Introduce this concept

- #cite(<themanorSustainabilityNotSacrifice2022>, form: "prose")

- Sustainability is hard. Green Filter helps you find companies that are making a true effort and build closer relationships through shopping, savings, and investing. Green Filter helps you find companies that are making a true effort to become sustainable and build closer relationships through shopping, savings, and investing

- Gather requirements and build a prototype for the next-generation investment app for young adults. Improving the user experience for young adults getting started with (green) investing. What would a "Tinder for (Green) Investments" look like? How can we make the logistics of investing so easy to use and take into account my values?

- My thesis core message is : everyone should change from consumer to sustainability investor (define these terms in the thesis). how to do this? can help you become from consumer to investor i believe there’s space for a product like that. your green investing friend find the companies tackling certain problems and invest in them using crypto business can be a force for good

== 'Shopping-as-Investing'
<shopping-as-investing-1>
- Consumer purchases are an indicator of demand. If demand trends down, companies will stop producing this product.

== 'Investment-as-Product'
<investment-as-product>
- Green Filter helps you discover how to save money and the planet with your daily shopping. By providing an easy way for people to learn about and shop with sustainable companies, we imagine a world where people invest in their future, find great deals on responsibly-made products, and get useful discounts from socially responsible brands.

- GreenFilter is a product that combines AI, design and marketing to help people manage their social impact throughout the stages of their lives, from young adult years to retirement. Its primary goal is to give people the tools they need to invest responsibly in sustainable companies, while also educating them on this topic. Our project offers a responsive website and mobile app that leverages AI and other advanced technologies. In addition, our prototype includes a reality-based virtual assistant with voice command capabilities which can provide customers with new insights into the world of green finance

- GreenFilter introduces a novel, interactive point-of-sale technology that helps people make greener shopping decisions. The platform uses artificial intelligence to suggest green alternatives for products on your shopping list, and will also help you to find other companies that can make sustainable versions of the product you are buying.

- As people become aware of the impact their shopping is having on the environment, they become interested in finding alternatives to big brands and large companies. GreenFilter provides designers an AI companion design which helps people build relationships with sustainability-focused companies by providing personalized recommendations, giving product reviews and helping them shop sustainably. This new tool will empower consumers to make greener choices throughout their lives.

- Better management of planet Earth

- How can wee Shop, Save, Invest in line ecologic principles and planetary boundaries? individual action doesn’t move the needle. how to group together

- App to build community

- Life within planetary boundaries

- Currently it seems there’s a secret around how things are produced we want to increase transparency

- Companies that have nothing new nothing to hide should welcome this opportunity to mark themselves to keep a conscious consumers and investors.

- We want to create competition around sustainable practices enter widespread adoption

- Cigarettes and pictures of lung cancer every product should be required to have photos of production conditions switch such as Rainforest and deforestation the products that include Palm oil.

- My thesis is that a lot of people want to do good, shop eco-friendly, invest green, etc. But they don’t believe the solutions work. They don’t have trust. This is a user interface issue. How to build trust.

#horizontalrule

title: Early Feature Ideas sidebar\_position: 1 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= Early Feature Ideas
<early-feature-ideas>
The following early prototypes are focused on particular feature ideas that occurred to me during the literature review process. They are naive and meant to allow thinking in terms of #emph[what-if] a particular user experience was possible. These prototypes were not tested with users directly and formed a basis for directing the questions asked in a potential user survey.

= Susan (Sustainability Conversation)
<susan-sustainability-conversation>
#emph[What if] I could have a chat like this at the supermarket? Imagine what questions I would ask before buying a product. AI: "Kris, do you still remember Coca Cola’s packaging is a large contributor to ocean plastic? You even went to a beach cleanup!" Me: "That’s so sad but it’s tasty!" AI. "Remember your values. Would you like to start saving for investing in insect farms in Indonesia instead? Predicted return 4% per year, according to analysts A and B." If I’m not so sure, I could continue the conversation. Me: "Tell me more" AI: "A recent UN study says, the planet needs to grow 70% more food in the next 40 years. Experts from 8 investment companies predict growth for this category of assets." Me: "Thanks for reminding me who I am" … Moments later. AI: "This shampoo is made by Unilever, which is implicated in deforestation in Indonesia according to reporting by World Forest Watch. Would you consider buying another brand instead? They have a higher ESG rating."

Example Suggestions of the AI companion:

- "Don’t buy a car, use a car sharing service instead to save XYZ CO2. Service available near you: Bolt,\* Uber."

- "Use a refillable shampoo bottle to save XYZ plastic pollution"

- "Call your local politician to nudge them to improve bicycle paths and reduce cars in your neighborhood. Over the past 2 years, you city has experienced an increase of cars from 290 cars per capita to 350 cars per capita."\*

Figure 3: Speculative scenario of an interaction between a human user and a robo-advisor through the interface of chat messages in the context of retail shopping for daily products.

https:\/\/scontent.ftpe6-1.fna.fbcdn.net/v/t39.8562-6/333078981\_693988129081760\_4712707815225756708\_n.pdf

provides many examples conversations between AI and humans from Meta’s LLAMA mmodel

== Sunday Market
<sunday-market>
#emph[What if] I could go to the Sunday market with other people who care about sustainability? First prototype (based on literature review) called HappyGreen’s for going to the organic Sunday Market with friends. Choose industries of focus? Fashion, Food, etc?

== True Cost
<true-cost>
#emph[What if] I you could see the actual cost of each product including externalities?

== Speak Truth to Power
<speak-truth-to-power>
#emph[What if] I could affect companies with truth? Consolidate user feedback for companies.

== How Far?
<how-far>
#emph[What if] I knew how far did this product travel to reach me?

== Country Profiles
<country-profiles>
#emph[What if] I knew my country’s top pollution sources?

== Know Your Company
<know-your-company>
#emph[What if] I could KYC the companies I interact with? Like the banks KYC, consumers can KYC.

== CO2e Flex
<co2e-flex>
#emph[What if] I could show off how much CO2e I have retired?

== Sustainability Watch
<sustainability-watch>
#emph[What if] I could see all my sustainability data on a wearable device in the right context?

== Narrative Layouts
<narrative-layouts>
#emph[What if] I spent 5 minutes every day with a guide who could help me make more eco-friendly choices? How should the layout storyline be structured? Well it’s like Strava (that running app) for sustainability… or if you have heard of Welltory. I believe sustainable choices that would improve my life.. be it what I consume, save, invest, etc.. so I’m trying to design an app around this idea. I’m basically building the UX of AI.. focused on sustainability. How should the layout storyline be structured? Well it’s like Strava (that running app) for sustainability… or if you have heard of Welltory. I believe if I spent 5 minutes every day with a guide who could help me make more eco-friendly choices that would improve my life.. be it what I consume, save, invest, etc.. so I’m trying to design an app around this idea.

== Shopping Divest
<shopping-divest>
#emph[What if] I you could build a community based on what I buy?

== Books Can Talk
<books-can-talk>
#emph[What if] sustainability literature could chat with me? Books can now talk to me. My bedtime story about shopping, saving, and investing. @SustainableShoppingSaving2023

- @raykurzweilIntroducingSemanticExperiences2018
- @baileyAIEducation2023

#horizontalrule

title: Interactive Prototype sidebar\_position: 1 editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= Interactive Prototype
<interactive-prototype>
- https:\/\/ai.ziran.tw/
-

== Testing
<testing>
== Retrieval-Augmented Generation (RAG)
<retrieval-augmented-generation-rag>
- "make contextual decisions on-the-fly, thereby opening up a more dynamic and responsive way to handle knowledge search tasks" #cite(<dewyBuildingRAGTool2024>, form: "prose")

== Prototype Development
<prototype-development>
– tools used: qr generator in Canva postman for API testing

- Google Chrome has 3.45 billion users #cite(<GoogleChromeStatistics2023>, form: "prose")

- Retrieval-Augmented Generation (RAG) to enhance AI content with domain-spefic (close-to realtime) knowledge.

- technique first proposed by researchers at META @lewisRetrievalAugmentedGenerationKnowledgeIntensive2020 some RAG benefits include \[#cite(<gaoRetrievalAugmentedGenerationLarge2023>, form: "prose");;\]

Prototype architecture

- Google Chrome browser extension

- ApI microservice

- Ziran AI

- AI backend

- Ratings API

- Redis testing ai results

- Redis Page cache / from page / separate scraping service

- documentation: GreenFilter: thesis website / github

- Ai Api got / claude

- Stock ratings API

- Community ratings api

70 qeustions questionairw - use report ID to do anonymois teating - page tracking to track the usage - 7 app wuestions - 63 pwrsonality wuestion

#horizontalrule

title: Testing sidebar\_position: 8 execute: echo: false editor: render-on-save: false suppress-bibliography: true

#horizontalrule

= Testing
<testing-1>
Does the prototype match user needs?

== App Testing Flow
<app-testing-flow>
== Testing Period
<testing-period>
- 1 month from 2024 April 2 to May 2, 2024
- 30 individual participantsbö

== Testing
<testing-2>
Prototype Testing results

sun, 14. april. 22h at D24

- ncku student, gen-z
- searches for lancome brand
- chooses LANCOME 蘭蔻 小黑瓶100ml(買一送一/超未來肌因賦活露國際航空版) https:\/\/www.momoshop.com.tw/goods/GoodsDetail.jsp?i\_code=12028429&Area=search&oid=1\_8&cid=index&kw=lancome
- notices 買一送一
- doesn’t notice analysis button at first
- would only click on this if it’s really expensive
- would not click on "continue chat button"
- asked “why is it so expensive in taiwan2
- considers report result useful

note: there’s dropoff on evey step of the user journey

RQ: To what extend can shopping become and entry point for saving and investing. RQ: Can shopping serve as an entry point for sustainable saving and investing?

Testing overview

- Tested with 30 participants individually
- Testing is anonymous
- Generate
-

有意識的消費主義

- add carbon indicators, other labels to the analsysi, add report code, calculate report code from URL? ssave as kv

#figure(
  align(center)[#table(
    columns: (4.17%),
    align: (auto,),
    [may 8 czuta],
    [- investment help useless.. needs simpler intro - wants to see real cows - very curious abouut companes - wants to see profit percentage. why is margin so high if polluution is bad. - real environmental impact of the coompany.],
  )]
  , kind: table
  )

06 may - Seeing factory photos is useful only if they are trustworthy photos. Who will provide them? -

#horizontalrule

may 5 - user: it looks like an ad -

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    [may 3],
    [- uses google to look for "fashion brand eco friendly"],
    [- thinks "goodonyou.eco" looks like a brand website],
  )]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: (6.94%),
    align: (auto,),
    [may3 - first looked for NET clothes but Momo doesn’t sell it - Looked for Sony camera lens],
  )]
  , kind: table
  )

1 may prof suggestion - make connection between biodibersity and production and consumption clearer - what is the incentive for companies to share their data?

my own idea: like the switch of going from traditional banking with ATM machines on the street (or even the physica bank office) to online banking with mobile payments

- hypothesis: esg accessibility can push companies to increase production standards

- what if you can see ESG in near-realtime such as the stock market price

- i can imagine esg derivative product like siemens gamesa

- ai can help integrate esg derivatives into daily life to drive esg adoption

- "effective altruism (EA)"

- "Blockchain technology can improve price transparency in product distribution by allowing consumers to know the exact pricing from raw materials to distributors to suppliers."

-

Interviews and testing survey were conducted anonymously in hopes to have more honest responses from the responders.

- ziran chrome extension is unable to record activity due to browser security restrictions for plugins
- ai.ziran.tw record user activity
- semi-structured interviews were conducted in chinese
- the interviewer (me) took notes of the interviews
- some gaps in the data exist due to the limited chinese language skills of the interviewer (me)

basic interview script - momo: what is a brand that you like’d or would like to buy - search - please pick a product (or search again) - on product page: what do you notice on this page? - what kind of information is important for you on this page? - do you notice anything else - (if the user doesn’t notice the green filter, direct their attention to it and ask: what do you think this does?) - would you click on it - if the user says yes, continue - if thhe user says no, make note and continue - as the extension generates a response: what do you think about this content? - is there any information that you consider important? - anything else you see that you think looks special - do you see anywhere you can click? - would you click on it? - if yes, continue - if no, make note, and continue - explain: due to the limitation of the prototype, the test will continue on a separate page where you can ask questions - is there anything you would like to ask the helper? - notice if the user picks from sample questions - remind the user they can come up with their own question - as the ai is generating content ask: do you see any information in this content - did you know this before or is there any info you didn’t know before? make note. - front page: explain the helper takes into account your personal info and goals. - ask: what kind of information do you think important to share with the helper?

Tuesday 30. April 14:05-14:45 - 7CYQ6

- Momo
- Looks for Levis pants
- Looks for recommendations on the sidebar
- Looks at the photos
- Looks at the price and options
- Didn’t notice the helper as it looks like an ad
- When helped
- Ignores 社區支持： 購物 69% 儲蓄 80% 投資 65% as doesn’t know what these mean
- on ai.ziran
- shares personal info: 四年後想考研究所，還不想工作，所以不會存到錢，希望可以考到台北的學校，每個月有兩萬生活費。
-
- DJmoney
- https:\/\/www.moneydj.com/etf/x/basic/basic0004.xdjhtm?etfid=0050.tw
- Still didn’t notice the helper
- Doesn’t understand investing (Understands it’s Taiwanese stocks) so the helper is useful for explaining new concepts

Monday 29. april 10:10-10.25 - Momo - buy new balance sneakers

- DJmoney
- wants compare EFTs

Monday 29. april 14:50-15:10 - Momo - buy apple iphone - bad internet - app was slow - app crashed

- green filter analysis on DJmoney seems more trustworthy than other 2 eft sites
- button placement is important (too low on other sites than djmoney)

Sunday 28. april 16:00 - momo: wants to buy ice cream

sun, 14. april. 22h at D24

- ncku student, gen-z
- searches for lancome brand
- chooses LANCOME 蘭蔻 小黑瓶100ml(買一送一/超未來肌因賦活露國際航空版) https:\/\/www.momoshop.com.tw/goods/GoodsDetail.jsp?i\_code=12028429&Area=search&oid=1\_8&cid=index&kw=lancome
- notices 買一送一
- doesn’t notice analysis button at first
- would only click on this if it’s really expensive
- would not click on "continue chat button"
- asked “why is it so expensive in taiwan2
- considers report result useful

note: there’s dropoff on evey step of the user journey

RQ: To what extend can shopping become and entry point for saving and investing. RQ: Can shopping serve as an entry point for sustainable saving and investing?

Testing overview

- Tested with 30 participants individually
- Testing is anonymous
- Generate
-

有意識的消費主義

- add carbon indicators, other labels to the analsysi, add report code, calculate report code from URL? ssave as kv

https:\/\/www.youtube.com/watch?v=xLszCaeUWig

https:\/\/www.youtube.com/watch?v=GHMAboJvLCU

https:\/\/www.youtube.com/watch?v=xLszCaeUWig

https:\/\/www.carbonequity.com/what-we-offer

#bibliography("ref.bib")

