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
  title: [Sustainability],
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)


= Evolving Sustainability Measurments from Planetary Boundaries to Planetary Health
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

=== Planetary Boundaries
<planetary-boundaries>
- As long as humanity is a mono-planetary species, we have to come to terms with the limitations of our home, Earth.

== Planetary Health
<planetary-health>
- Planetary health https:\/\/unfccc.int/climate-action/un-global-climate-action-awards/planetary-health

- #cite(<wardaniBoundariesSpacesKnowledge2023>, form: "prose") #emph["long-term human well-being is dependent on the well-being of the planet, including both biotic and abiotic systems. It recognizes interlinkages across environmental sustainability, public health, and socioeconomic development."]

== Biodiversty Loss
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

= Ecological Indicators of the Biosphere
<ecological-indicators-of-the-biosphere>
Sustainability can be measured using a variety of #strong[#emph[ecological indicators];];.

#cite(<dinersteinEcoregionBasedApproachProtecting2017>, form: "prose") identifies 846 terrestrial ecoregions.

- Svalbard Seed Vault
- #cite(<jacksonMaterialConcernsPollution1996>, form: "prose") #emph[preventive environmental management]
- #cite(<jacksonProsperityGrowthFoundations2017>, form: "prose") limits to growth update
- Ecological Indicators (I like the name Ecomarkers) for Earth are like Biomarkers in human health.

Some argue sustainability is not enough and we should work on regeneration of natural habitats.

== The Climate
<the-climate>
=== The Price of Climate Change
<the-price-of-climate-change>
Long term cost is more than short-term gains.

=== Climate Data Vizualisation
<climate-data-vizualisation>
Climate data visualization has a long history, starting with #strong[#emph[Alexander von Humboldt,];] the founder of climatology, who revolutionized cartography by inventing the first #emph[isothermal maps] around the year 1816; these maps showed areas with similar temperature, variations in altitude and seasons in different colors @hontonForgottenFatherClimatology2022. Humboldt’s isotherms are now available as 3D computer models in @IsothermsSimplyEarth2023.

Earth’s physical systems are very sensitive to small changes in temperature, which was not understood until 30 years ago @mckibbenEndNature2006.

- Industrial revolution: : "transition to a low carbon economy presents challenges and potential economic benefits that are comparable to those of previous industrial revolutions" @pearsonLowCarbonIndustrial2012.
- Tragedy of the commons: @meisingerTragedyIntangibleCommons2022@lopezClimateChangeTimes2022@muraseSevenRulesAvoid2018.

Earth System Models from the first calculation by Svante Arrhenius and Guy Stewart Callendar to today’s complex models that integrate the various Earth systems and cycles ran on supercomputers #cite(<andersonCO2GreenhouseEffect2016>, form: "prose")

== Climatech
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

== Ecosystem Services Enable Life on Earth
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

== #strong[Environmental Degradation Is Cir]
<environmental-degradation-is-cir>
=== Growing Population and Overpopulation
<growing-population-and-overpopulation>
Earth’s population reached 8 Billion people In November 2022 and population projections by predict 8.5B people by 2030 and 9.7B by 2050 @theeconomictimesClimateChangeEarth2022@unWorldPopulationProspects2022.

@hassounFoodProcessingCurrent2023 forecasts increase of global food demand by 62% including impact of climate change.

- While population growth puts higher pressure on Earth’s resources, some research proposes the effect is more from wasteful lifestyles than the raw number of people @cardinaleBiodiversityLossIts2012.

- #cite(<bowlerMappingHumanPressures2020>, form: "prose") Anthropogenic Threat Complexes (ATCs):

- "Overpopulation is a major cause of biodiversity loss and smaller human populations are necessary to preserve what is left" #cite(<cafaroOverpopulationMajorCause2022>, form: "prose");.

=== Marine Heatwaves
<marine-heatwaves>
- @smaleMarineHeatwavesThreaten2019[ and #cite(<gellesOceanDireMessage2023>, form: "prose");] describe how marine heatwaves threaten global biodiversity.

=== Slavery Still Exists
<slavery-still-exists>
In 2023, an estimated 50 million people are still in slavery around the world; lack of supply chain visibility hides forced labor and exploitation of undocumented migrants in agricultural work; 71% of enslaved people are estimated to be women. @kunzAdoptionTransferabilityJoint2023@borrelliCareSupportMaternity2023.

The UN SDG target 8.7 targets to eliminate all forms of slavery.

Slavery is connected to environmental degradation and climate change @deckersparksGrowingEvidenceInterconnections2021. Enslaved people are used in environmental crimes such as 40% of deforestation globally. Cobalt used in technological products is in risk of being produced under forced labor in the D.R. Congo @sovacoolWhenSubterraneanSlavery2021. In India and Pakistan, forced labor in brick kiln farms is possible to capture remotely from satellite images @boydSlaverySpaceDemonstrating2018. In effect, the need for cheap labor turns slavery into a #emph[subsidy] keeping environmental degradation happening.

- #cite(<christBlockchainTechnologyModern2021>, form: "prose") estimates 20 million people are stuck inside corporate blockchains. The Global Slavery Index measures the #strong[#emph[Import Risk];] of having slavery inside its imports #cite(<walkfreeGlobalSlaveryIndex2023>, form: "prose");.

- #cite(<hansvanleeuwenModernSlaveryGrace2023>, form: "prose") slavery affects industries from fashion to technology, including sustainability enablers such as solar panels.

- "commodification of human beings"

- #cite(<anandchandrasekharWhySwitzerlandMatters2021>, form: "prose");: Trading commodities "Switzerland has a hand in over 50% of the global trade in coffee and vegetable oils like palm oil as well as 35% of the global volume of cocoa, according to government estimates." Can traders have more scrutiny over what they trade?

- Modern Slavery Act.

=== Overconsumption Drive Climate Change
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

== Earth System Law
<earth-system-law>
- #cite(<dutoitReimaginingInternationalEnvironmental2022>, form: "prose") describes Earth System Law as a framework for addressing interconnected environmental challenges.

- #cite(<williamsIntensificationWinterTransatlantic2013>, form: "prose") higher CO#sub[2] concentrations in the air can cause more turbulence for flights.

- Warmer climate helps viruses and fungi spread #cite(<pressFungalDiseaseRapidly2023>, form: "prose")

== Biodiversity is Decreasing Rapidly
<biodiversity-is-decreasing-rapidly>
#cite(<livingPlanetReport2022>, form: "prose") reported, the number of species killed, mass destruction of nature. "69% decline in the relative abundance of monitored wildlife populations around the world between 1970 and 2018. Latin America shows the greatest regional decline in average population abundance (94%), while freshwater species populations have seen the greatest overall global decline (83%)."

```python
import matplotlib.pyplot as plt
import matplotlib.font_manager as font_manager

categories = ['Worldwide', 'Latin America', 'Freshwater Species']
declines = [69, 94, 83]
colors = ['#fb81cb', '#3ec7b8', '#fee566']

custom_font = font_manager.FontProperties(fname='fonts/notosans.ttf')

plt.figure(figsize=(10, 6))
bars = plt.bar(categories, declines, color=colors)

for bar in bars:
    yval = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, yval - 5, f"{yval}%", ha='center', va='bottom', fontproperties=custom_font, fontsize=20, color='black')

plt.show()
```

#box(image("sustainability_files/figure-typst/cell-2-output-1.svg"))

Biodiversity loss is linked to overconsumption, weak legislation and lack of oversight. @crennaBiodiversityImpactsDue2019 recounts European Union consumers’ negative impact on biodiversity in countries where it imports food. #cite(<wwfForestsReducingEU2022>, form: "prose") case study highlights how 4 biodiverse regions Cerrado in Brazil, Chaco in Argentina, Sumatra in Indonesia, and the Cuvette Centrale in Democratic Republic of Congo are experiencing rapid destruction due to consumer demand in the European Union. While the European Union (EU) has recently become a leader in sustainability legislation, biodiversity protection measures among private companies is very low #cite(<marco-fondevilaTrendsPrivateSector2023>, form: "prose");.

Meanwhile, there is some progress in biodiversity conservation. #cite(<uebtBiodiversityBarometer2022>, form: "prose") reports "Biodiversity awareness is now at 72% or higher in all countries sampled, compared to only 29% or higher across countries sampled in 2009."

Similarly to climate protection, the UN has taken a leadership role in biodiversity protection. #cite(<unitHistoryConvention2023>, form: "prose");: The history of the United Nations Convention on Biodiversity goes back to 1988, when the working group was founded. #cite(<unepCOP15EndsLandmark2022>, form: "prose");: The Convention on Biodiversity 2022 (COP15) adopted the first global biodiversity framework to accompany climate goals.

=== #strong[#emph[Biodiversity Indicators];]
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

=== Forest and Deforestion
<forest-and-deforestion>
Around 27% of Earth’s land area is still covered by forests yet deforestation is widespread all around the world; highest rates of deforestation happened in the tropical rainforests of South America and Africa, mainly caused by agricultural cropland expansion (50% of all deforestation) and grazing land for farm animals to produce meat (38,5%), totaling close to 90% of global deforestation @FRA2020Remote2022. Forests are a crucial part of Earth’s carbon cycle and the main natural CO#sub[2] capture system; due to deforestation, Europe rapidly losing its forest carbon sink @fredericsimonEuropeRapidlyLosing2022.

Afforestation is different from reforestation, which takes into account biodiversity.

- #cite(<klostermanMappingGlobalPotential2022>, form: "prose") using remote-sensing and machine-learning to assess reforestation potential; doesn’t take into account political realities.

- Global Forest Cover Change, Earth Engine #cite(<hansenHighResolutionGlobalMaps2013>, form: "prose")

- 1 billion tree project @greenfieldVeNeverSaid2021@ErratumReportGlobal2020@bastinGlobalTreeRestoration2019

- Burning of biomass undermines carbon capture.

=== Air and Water Pollution is Widespread
<air-and-water-pollution-is-widespread>
- Clean water and water pollution
- #cite(<kochOpinionArizonaRace2022>, form: "prose") (#strong[Need access! nyc times)]

Air pollution is widespread around the planet, with 99% of Earth’s human population being affected by bad air quality that does not meet WHO air quality guidelines, leading to health problems linked to 6.7 million premature deaths every year #cite(<worldhealthorganizationAmbientOutdoorAir2022>, form: "prose");. Grounbreaking research by #cite(<lim1MOAirPollutioninduced2022>, form: "prose") analyzed over 400000 individuals in England, South Korea and Taiwan establishes exposure to 2.5μm PM (PM2.5) air pollution as a cause for lung cancer. #cite(<bouscasseDesigningLocalAir2022>, form: "prose") finds strong health and economic benefits across the board from air pollution reduction in France. In #cite(<hannahdevlinCancerBreakthroughWakeup2022>, form: "prose");, prof Tony Mok, of the Chinese University of Hong Kong: "We have known about the link between pollution and lung cancer for a long time, and we now have a possible explanation for it. As consumption of fossil fuels goes hand in hand with pollution and carbon emissions, we have a strong mandate for tackling these issues – for both environmental and health reasons".

Health and sustainability are inextricably linked. "Human health is central to all sustainability efforts.", "All of these (food, housing, power, and health care), and the~stress~that the lack of them generate, play a huge role in our health" @sarahludwigrauschSustainabilityYourHealth2021.

The main way to combat air pollution is through policy interventions. #cite(<marialuisfernandesRealityCheckIndustrial2023>, form: "prose") EU has legislation in progress to curb industrial emissions. If legislation is in place, causing bad air quality can become bad for business. #cite(<guHiddenCostsNongreen2023>, form: "prose") links air pollution to credit interest rates for business loans in China; companies with low environmetal awareness and a history of environmental penalties pay 12 percent higher interest rates.

Clean air is a requirement.

=== Climate Change Disasters
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

=== Carbon Accounting in Corporate Industry
<carbon-accounting-in-corporate-industry>
- Watershed

- The legislation has created an industry of CO#sub[2] accounting with many companies like Greenly, Sustaxo, etc.

- #cite(<quatriniChallengesOpportunitiesScale2021>, form: "prose") sustainability assessments are complex and may give flawed results.

- Nonetheles, CO#sub[2] emission reduction has the added positive effect of boosting corporate morale @caoImpactLoweringCarbon2023.

== Agroforestry & Permaculture
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

== Quality of Life
<quality-of-life>
- #cite(<kaklauskasSynergyClimateChange2023>, form: "prose")

- #cite(<riegerIntegratedScienceWellbeing2023>, form: "prose") Integrated science of wellbeing

- #cite(<fabrisCLIMATECHANGEQUALITY2022>, form: "prose")

- Sustainability is part of product quality. If a product is hurting the environment, it’s a low quality product.

== Restoration Ecology
<restoration-ecology>
- Bioswales

- #cite(<fischerMakingDecadeEcosystem2021>, form: "prose") UN announced 2021–2030 the Decade on Ecosystem Restoration

== #strong[Environmental DNA]
<environmental-dna>
- #cite(<ogramExtractionPurificationMicrobial1987>, form: "prose") isolating cellular DNA from various sediment types.

- #cite(<peterandreysmitharchivepageHowEnvironmentalDNA2024>, form: "prose") describes

== Digital Twins
<digital-twins>
- We can use all the data being recorded to provide a Digital Twin of the planet, nature, ecosystems and human actions to help us change our behavior and optimize for planetary wellbeing.

- The EU is developing a digital twin of Earth to help sustainability prediction and planning, integrating Earth’s various systems such as climate, hydrology, ecology, etc, into a single model @hoffmannDestinationEarthDigital2023[ and #cite(<DestinationEarthShaping2023>, form: "prose");];.

- EU releases strategic foresight reports since 2020 #cite(<europeancommissionStrategicForesight2023>, form: "prose")

= Mitigation & Adaption
<mitigation-adaption>
Many companies are developing technologies for mitigation.

=== Cap & Trade
<cap-trade>
The share of CO#sub[2] emissions among people around the world is highly unequal across the world (referred to as #strong[#emph[Carbon Inequality];];). @chancelGlobalCarbonInequality2022 reports "one-tenth of the global population is responsible for nearly half of all emissions, half of the population emits less than 12%".

- One example is the ICT sector.

- #cite(<bajarinPCSalesAre>, form: "prose") Over 300 million PCs sold in 2022

  - #cite(<GreenDiceReinventingIdea2021>, form: "prose") Estonian company "sustainable lifecycle management of IT equipment"
  - #cite(<arilehtKestlikkuseSuunanaitajadSaadavad2022>, form: "prose") Recycle your phone, FoxWay and Circular economy for PCs.
  - #cite(<zhouCarboneconomicInequalityGlobal2022>, form: "prose") ICT is an example of inequality, while emerging economies bear 82% of the emissions, developed countries gain 58% of value.

== Emissions’ Data
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

== Emissions Trading Schemes
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

== Carbon Markets
<carbon-markets>
For the individual person, there’s no direct access to CO#sub[2] markets, however there are different types of brokers who buy large amounts of carbon credits and resell them in smaller quantities to retail investors. "Carbon pricing is not there to punish people," says Lion Hirth #cite(<lionhirthLionHirthTwitter>, form: "prose");. "It’s there to remind us, when we take travel, heating, consumption decisions that the true cost of fossil fuels comprises not only mining and processing, but also the damage done by the CO#sub[2] they release."

=== The Price of CO#sub[2] Differs Across Markets
<the-price-of-co2-differs-across-markets>
#cite(<sternCarbonNeutralEconomy2022>, form: "prose") reports carbon-neutral economy needs higher CO#sub[2] prices. #cite(<rennertComprehensiveEvidenceImplies2022>, form: "prose");: Carbon price should be 3,6x higher that it is currently. #cite(<ritzGlobalCarbonPrice2022>, form: "prose") argues optimal CO#sub[2] prices could be highly asymmetric, low in some countries and high (above the social cost of CO#sub[2];) in countries where production is very polluting.

- #cite(<igeniusLetTalkSustainable2020>, form: "prose")
- The total size of carbon markets reached 949 billion USD in 2023, including Chinese, European, and North American CO2e trading @lsegGlobalCarbonMarkets2024.

=== Compliance Markets
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

=== Voluntary Carbon Markets
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

=== Fossil Fuels
<fossil-fuels>
Fossil fuels are what powers humanity as well as the largest source of CO#sub[2] emissions. #cite(<ieaGlobalEnergyReview2022>, form: "prose") reports "Global CO#sub[2] emissions from energy combustion and industrial processes rebounded in 2021 to reach their highest ever annual level. A 6% increase from 2020 pushed emissions to 36.3 gigatonnes". As on June 2023, fossil fuel based energy makes up 82% of energy and is still growing #cite(<instituteEnergySystemStruggles2023>, form: "prose");. The 425 largest fossil fuel projects represent a total of over 1 gigatons in CO#sub[2] emissions, 40% of which were new projects #cite(<kuhneCarbonBombsMapping2022>, form: "prose");. #cite(<tilstedEndingFossilbasedGrowth2023>, form: "prose") expects the fossil fuel industry to continue grow even faster. In July 2023, the U.K. granted hundreds of new oil and gas of project licenses in the North Sea @RishiSunakGreenlight2023.

=== Renewable Energy
<renewable-energy>
- 10 countries use almost 100% renewable energy

There’s ample evidence from several countries suggesting moving to renewal energy brings environmental benefits:

- #cite(<AMIN2022113224>, form: "prose") suggests "removing fossil fuel subsidies and intra-sectoral electricity price distortions coupled with carbon taxes provides the highest benefits" for both the economy and the environment in Bangladesh.

- #cite(<luoControllingCommercialCooling2022>, form: "prose") suggests using reinforcement learning to reduce energy use in cooling systems.

- The true cost of products is hidden. The work is hidden.

- Montreal protocol eradicates CfCs and the ozone holes became whole again.

=== Emission Scopes Organize Calculating CO2e
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

=== Carbon Capture
<carbon-capture>
Many technology startups focused on climate solutions (often referred to as climatech by the media), have proposed a range of approaches to CO#sub[2] reduction in the atmosphere.

- #cite(<vitilloRoleCarbonCapture2022>, form: "prose") illustrates how direct air capture of CO#sub[2] is difficult because of low concentration and CO#sub[2] capture at the source of the emissions is more feasible.

- #cite(<gaureTrueNotTrue2022>, form: "prose") simulate a CO#sub[2] free electricity generation system in the European Union where "98% of total electricity production is generated by wind power and solar; the remainder is covered by a backup technology.". The authors stipulate it’s possible to power the EU without producing CO#sub[2] emissions.

- #strong[Important: "creating sustainability trust in companies in realtime"]

- #cite(<howardPotentialIntegrateBlue2017>, form: "prose") argues Oceans play crucial role in carbon capture.

=== Social Cost of Carbon Measures Compound CO#sub[2] Impact
<social-cost-of-carbon-measures-compound-co2-impact>
Sustainability is filled with complexities, where CO#sub[2] emission is compounded by biodiversity loss, child labor, slavery, poverty, prostitution, dangerous chemicals, and many other issues become intertwined @tedxSustainableBusinessFrank2020. One attempt to measure these complexities, is the Social Cost of Carbon (SCC) which is defined as "additional damage caused by an extra unit of emissions" @kornekSocialCostCarbon2021@zhenSimpleEstimateSocial2018. For example the cost of damages caused by "one extra ton of carbon dioxide emissions" @stanforduniversityProfessorsExplainSocial2021. SCC variations exists between countries @tolSocialCostCarbon2019 and regions @wangMeasurementChinaProvincial2022.

- As shown in the Phillipines by @chengAssessingEconomicLoss2022, with increasing extreme weather events, "businesses are more likely to emerge in areas where infrastructure is resilient to climate hazards". @jerrettSmokeCaliforniaGreenhouse2022 says, In California, "Wildfires are the second most important source of emissions in 2020" and "Wildfires in 2020 negate reductions in greenhouse gas emissions from other sectors."

- @linOpportunitiesTackleShortlived2022 says, apart from CO#sub[2];, reduction of other atmospheric pollutants, such as non-CO#sub[2] greenhouse gases (GHGs) and short-lived climate pollutants (SLCPs) is required for climate stability.

- @wangMultimodelAssessmentClimate2022: Quantifying climate damage proposes scenarios of climate damage.

=== Country-Level Nationally Determined Contributions (NDCs)
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

=== SDGs
<sdgs>
- SDGs need to discussed in their totality #cite(<popkovaTheoryDigitalTechnology2022>, form: "prose");.

- German Institute of Development and Sustainability (IDOS) connects SDGs to NDCs. #cite(<dzeboParisAgreementSustainable2023>, form: "prose")

- International Energy Agency (IEAs), Decarbonisation Enablers #cite(<ieaTrackingCleanEnergy2023>, form: "prose")

= Eco-Design
<eco-design>
#strong[#emph[Designing for Sustainability aka Circular Design or Eco-Design];] encompasses all human activities, making this pursuit an over-arching challenge across all industries also known as circular economy. Assuming that as individuals we want to act in a sustainable way, how exactly would be go about doing that?

- "Evolution of design for sustainability: From product design to design for system innovations and transitions"

- #cite(<DELAPUENTEDIAZDEOTAZU2022718>, form: "prose") #strong[Life Cycle Assessment and environmental impact analysis are needed to provide eco-design scenarios.]

- #cite(<europeanparliamentEcodesignSustainableProducts2022>, form: "prose") proposal "On 30 March 2022, the European Commission put forward a proposal for a regulation establishing a general framework for setting eco-design requirements for sustainable products, repealing rules currently in force which concentrate on energy-related products only." Virginijus Sinkevičius, EU Commissioner for the Environment, Oceans and Fisheries, is quoted as describing eco-design "respects the boundaries of our planet" #cite(<europeancommissionGreenDealNew2022>, form: "prose")

- Forming an emotional bond with the product makes it feel more valuable @zonneveldEmotionalConnectionsObjects2014. This has implications for sustainability as the object is less likely to be thrown away.

== Regenerative design
<regenerative-design>
- Dematerialize economies is not enough.

== Biomimicry
<biomimicry>
- following nature

== Biodesign
<biodesign>
MIT is a source of many fantastic innovations.

- Neri Oxman, biomaterials MIT media lab, 15. sept. 2020

- Neri Oxman’s expressions: "ecology-indifferent", "naturing", "mother naturing", "design is a practice of letting go of all that is unnecessary", "nature should be our single client".

- Use imagination

- Societal movements change things: implication for design: build a community

- Processes sustain things: implication for design: built an app

== AI-Assisted Design Enables Desiging for Sustainability
<ai-assisted-design-enables-desiging-for-sustainability>
#cite(<guptaAnalysisArtificialIntelligencebased2023>, form: "prose") argues software is key to building more sustainable products, already for decades. More recently, companies like AutoDesk are putting CO#sub[2] calculations inside their design software.

- AI has the potential to provide the parameters for sustainability. #cite(<singhArtificialNeuralNetwork2023>, form: "prose") proposes an AI tool for deciding the suitable life cycle design parameters.
- #cite(<SustainabilityStartsDesign>, form: "prose");: "Sustainability starts in the design process, and AI can help".

== Circular Economy
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

= Policy Context
<policy-context>
- "In the context of the EU Plastics Strategy, the European Commission has launched a pledge to increase the use of recycled content to 10 million tons by 2025. To address this, Circularise Plastics Group launched an “Open Standard for Sustainability and Transparency" based on blockchain technology & Zero-knowledge Proofs” #cite(<circulariseEuPCCircularisePlastics2020>, form: "prose")

- "data-exchange protocol with privacy at its heart" #cite(<circulariseCirculariseRaisesMillion2020>, form: "prose")

- EU AI Law #cite(<lomasDealEUAI2024>, form: "prose")

== The Policy Context in Europe From 2023 to 2030
<the-policy-context-in-europe-from-2023-to-2030>
We have an opportunity to re-imagine how every product can be an eco-product and how they circulate in our circular economy.

Timeline of the Policy Context:

- In 2019 by the von der Leyen commission adopted the European Union (EU) #strong[Green Deal] strategy.

- In 2021 the Commision proposed a goal of reducing CO2e emissions by 55% by 2030 under the #emph[Fit for 55] policy package consisting of a wide range of economic measures.

- In November 2022, the proposal was adopted by the EU Council and EU Parliament with an updated goal of 57% of CO2e reductions compared to 1990. This proposal is set to become a binding law for all EU member countries (#cite(<europeancommissionEuropeanGreenDeal2019>, form: "prose");; #cite(<europeancommissionSustainableEurope20302019>, form: "prose");; #cite(<EUReachesAgreement2022>, form: "prose");; #cite(<europeancouncilFit55EU2022>, form: "prose");).

- In March 2022, the EU Circular Economy Action Plan was adopted, looking to make sustainable products #emph[the norm] in EU and #emph[empowering consumers] as described in #cite(<europeancommissionCircularEconomyAction2022>, form: "prose");. Each product covered by the policy is required to have a #strong[#emph[Digital Product Passport];] which enables improved processing within the supply chain and includes detailed information to empower consumers to understand the environmental footprint of their purchases. It’s safe to say the large majority of products available today do not meet these criteria.

=== Wellbeing Economy Governments is an Example of Country-level Collaboration
<wellbeing-economy-governments-is-an-example-of-country-level-collaboration>
- Finland, Iceland, New Zealand, Scotland, Wales, Canada https:\/\/weall.org/wego

== European Green Deal
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

== Eco-Design is a Key EU Sustainable Policy Design Tool
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

== Sustainbility Policy is Shifting Around the World
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

== Waste Generation is Still Increasing
<waste-generation-is-still-increasing>
#cite(<liuGlobalPerspectiveEwaste2023>, form: "prose") reports, e–waste is growing 3%–5% every year, globally. @thukralExploratoryStudyProducer2023 identifies several barriers to e-waste management among producers including lack of awareness and infrastructure, attitudinal barriers, existing #emph[informal] e-waste sector, and the need for an e-waste license.

== Extended Producer Responsibility Enables Compannies to be Resposible
<extended-producer-responsibility-enables-compannies-to-be-resposible>
Extended Producer Responsibility (EPR) is a policy tool first proposed by Thomas Lindhqvist in Sweden in 1990 \[ADD CITATION\], aimed to encourage producers take responsibility for the entire life-cycle of their products, thus leading to more eco-friendly products. Nonetheless, EPR schemes do not guarantee circularity and may instead be designed around fees to finance waste management in linear economy models @christiansenExtendedProducerResponsibility2021. The French EPR scheme was upgraded in 2020 to become more circular @jacquesvernierExtendedProducerResponsibility2021.

In any case, strong consumer legislation (such as EPR) has a direct influence on producers’ actions. For example, in #cite(<hktdcresearchFranceExpandsProducer2022>, form: "prose");, the Hong Kong Trade Development Council notified textile producers in July 2022 reminding factories to produce to French standards in order to be able enter the EU market. #cite(<pengExtendedProducerResponsibility2023>, form: "prose") finds that the #strong[#emph[Carbon Disclosure Project];] has been a crucial tool to empower ERP in Chinese auto-producers.

- The success of EPR can vary per type of product. For car tires, the EPR scheme in the Netherlands claims a 100% recovery rate #cite(<campbell-johnstonHowCircularYour2020>, form: "prose");.

One type of legislation that works?

- #cite(<steenmansFosteringCircularEconomy2023>, form: "prose") Argues for the need to engage companies through legislation and shift from waste-centered laws to product design regulations.

- In Europe, there’s large variance between member states when in comes to textile recycling: while Estonia and France are the only EU countries where separate collection of textiles is required by law, in Estonia 100% of the textiles were burned in an incinerator in 2018 while in France textiles are covered by an Extended Producer Responsibility (EPR) scheme leading to higher recovery rates (Ibid).

- Greyparrot AI to increase recycling rates #cite(<natashalomasUKAIStartup2024>, form: "prose")

== Return, Repair, Reuse
<return-repair-reuse>
- There’s a growing number of companies providing re-use of existing items.
- #cite(<SmartSwap>, form: "prose") For example, Swap furniture in Estonia

Bring back your bottle and cup after use.

- #cite(<pastorProposingIntegratedIndicator2023>, form: "prose") proposes a #strong[product repairability index (PRI)]
- #cite(<formentiniDesignCircularDisassembly2023>, form: "prose")
- Recycling @lenovoFastTechUnsustainable2022 "rethinking product design and inspiring consumers to expect more from their devices"
- "design is a tool to make complexity comprehensible" like the Helsinki chapel. there’s either or a priest or a social worker. it’s the perfect public service. "limit the barrier of entry for people to discover". elegant.
- #cite(<zeynepfalayvonflittnerFalayTransitionDesign>, form: "prose")

== Packaging
<packaging>
Packaging is a rapidly growing industry which generates large amounts of waste #cite(<adaChallengesCircularFood2023>, form: "prose");. #cite(<bradleyLiteratureReviewAnalytical2023>, form: "prose");: "Over 161 million tonnes of plastic packaging is produced annually."

- #cite(<ChallengesOpportunitiesSustainable2022>, form: "prose")
- #cite(<ProteinBrandsConsumers2022>, form: "prose")
- #cite(<DetailrichSustainablePackaging2010>, form: "prose")
- @lernerHowCocaColaUndermines2019 Coca Cola plastic pollution. ESG ratings have faced criticism for lack of standards and failing to account for the comprehensive impact a company is having. @foleyRestoringTrustESG2024 notes how Coca Cola fails to account the supply chain water usage when reporting becoming "water neutral" and calls on companies to release more detailed information.
- #cite(<SulapacReplacingPlastic>, form: "prose")

== Factories Can Become More Transparent
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

= Design Implications
<design-implications>
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

#bibliography("../ref.bib")

