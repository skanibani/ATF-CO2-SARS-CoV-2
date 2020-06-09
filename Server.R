# UI maken

#teksten
tekst_intro_p1 <- "The aviation industry developed from ‘learning to fly’ to an industry that is the enabler of global business, in little over a century. 
At this point, the aviation industry accounts for about 3% of the total greenhouse gasses in Europe (European Commission, 2017).
According to ICAO, the air transport industry is expanding and the demand will continue to grow each year by an average of 4.3% (ICAO, n.d). 
This growth will result in more Air Traffic Movements (ATMs) and thereby increasing the total amount of emissions by aircraft (if no technology improvements increase the operational efficiency of aircraft)."
tekst_intro_p2 <- "However, from the beginning of 2020 a new virus named COVID-19 is spreading fast from China to countries all over the globe. 
In an attempt to limit the spread of the virus, the World Health Organization declared a Public Health Emergency of International Concern on 30 January 2020.
The following weeks the number of countries that implemented strong measures such as, quarantines, social distancing, travel restriction,
quarantine for arriving travellers, partial travel ban, and border closure, increases significantly when the number of COVID-19 cases in these countries rises."
tekst_intro_p3 <- "The impact of COVID-19 on the aviation industry is significant due to travel restriction to limit the spread of the virus reducing the number of passengers. 
In March 2020, the number of passengers is reduced with between 55%-75% in most countries, 
compared to the number of passengers in March 2019 (Air Transport Bureau, 2020). 
This decrease in the number of passengers results in a decrease in the number of ATMs (passenger flights).
Accordingly, this reduction results in a decrease in the amount of CO2 emissions by the aviation industry.  
The following question will be answered in this report:"
tekst_intro_p4 <-"What is the difference in the amount of CO2 emission caused by the current Air Traffic Movements in Europe,  
compared to the expected amount of CO2 emission caused by Air Traffic Movements if the COVID-19 outbreak had not happened?"
tekst_intro_p5 <- "The sub questions that are used to answer this main question are stated below and are explained in the following chapters accordingly.
1. How much CO2 is emitted per aircraft type per unit (distance, time, passenger)? 
2. What is the influence of a growing aviation industry on the CO2 emissions?
3. How does the amount of ATMs differ in 2020 due to COVID-19 compared to the expected amount of ATMs in 2020 if corona did not occur?
4. What type of Air Traffic Movements still occur during COVID-19? (commercial, cargo)"
tekst_intro_p6 <- "The objective of this research is to get an overview of the impact of COVID-19 on the CO2 emissions in Europe by the aviation industry. 
The result of this reserach is a model which respresents the CO2 emission of aircraft in Europe by collecting historical and current ATM "
assumptions <- "assumptions toevoegen"

deelvraag_1 <- "1.1 How much CO2 is emitted per aircraft type per unit (distance, time, passenger)?"
tekst_1 <- "..."
deelvraag_2 <- "1.2 What is the influence of growth of the aviation industry on CO2 emissions above Europe?"
tekst_2 <- "..."
deelvraag_3 <- "2.1 How does the amount of ATMs differ in 2020 due to the SARS-CoV-2 outbreak compared to the expected amount of ATMs in 2020?"
tekst_3 <- ".."
deelvraag_4 <- "2.2 What type of ATMs still occur during the pandamic? (commercial, cargo etc.)"
tekst_4 <- ".."
tekst_conclusie <- "conclusie is dat ..."
bronnen <- "bronnen toevoegen"

Opbouw_expl<- tabItem(tabName = "expl", 
                      h1("Final report"),
                      h2("Introduction"),
                      p(tekst_intro_p1),
                      p(tekst_intro_p2),
                      p(tekst_intro_p3),
                      strong(tekst_intro_p4),
                      br(),
                      p(tekst_intro_p5),
                      p(tekst_intro_p6),
                      h2("Assumptions"),
                      assumptions,
                      h2(deelvraag_1),
                      tekst_1,
                      h2(deelvraag_2),
                      tekst_2,
                      h2(deelvraag_3),
                      tekst_3,
                      h2(deelvraag_4),
                      tekst_4,
                      h2("Conclusion"),
                      tekst_conclusie,
                      h2("Bronnen"),
                      bronnen)


# UI maken
ui <- dashboardPage(
  dashboardHeader(title = "Impact of COVID-19 on the European Aviation",
                  titleWidth = 420),
  dashboardSidebar(
    width = 150,
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Explanation", tabName = "expl", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title = "Plot 1",solidHeader = TRUE, collapsible = TRUE),
                box(title = "Plot 2"),
                box(title = "Plot 3"),
                infoBox("ATM's", 11, icon = icon("credit-card")), #option interactive
                valueBox(11, "ATM's nieuw", icon = icon("credit-card")))),
      Opbouw_expl
    ))
)
# Server maken
server <- function(input, output) {
  set.seed(122)
}

# UI en server samenvoegen
shinyApp(ui, server)