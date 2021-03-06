library(shinycssloaders)
library(shinyBS)

filterPanel <- wellPanel(
  id = "searchpanel",
  p(strong("Filter Options"), br(), "Any combination of filters accepted."),
  selectizeInput(inputId = "journal", label="Journal", choices = NULL, multiple = TRUE, selected=NULL, options = list(placeholder = 'Select journal(s)')),
  div(style = "margin-top:-15px"),
  selectizeInput(inputId = "study", "Type of Research", choices = NULL, multiple = TRUE, selected=NULL, options = list(placeholder = 'Select research type(s)')),
  div(style = "margin-top:-15px"),
  selectizeInput(inputId = "bucket", "Type of Publication", choices = NULL, multiple = TRUE, selected=NULL, options = list(placeholder = 'Select publication type(s)')),
  div(style = "margin-top:-15px"),
  selectizeInput(inputId = "author", "Author(s)", choices = NULL, multiple = TRUE, selected=NULL, options = list(placeholder = 'Select author(s)')),
  div(style = "margin-top:-15px"),
  selectizeInput(inputId = "specialty", "Specialty", choices = NULL, multiple = TRUE, selected=NULL, options = list(placeholder = 'Select area(s) of interest')),
  div(style = "margin-top:-15px"),
  shinyWidgets::radioGroupButtons(inputId="specSwitch", size="sm", label="Specialty matches:", choices=c("Any term", "All terms"), selected="Any term", status="info"),
  div(style = "margin-top:-10px"),
  hr(),
  div(style = "margin-top:-15px"),
  p(textOutput("N", inline = TRUE), " result(s)."),
  fluidRow(
    column(6,shinyWidgets::dropdown(
      downloadButton(outputId = "export", label = "CSV", class="btn-secondary btn-sm"),
      status="btn-primary btn-sm",
      size="sm",
      label="Download"
    )),
    column(6, actionButton(inputId = "clearAll", "Clear", class="btn-primary btn-sm"))
  )
)

options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=2)


ui <- navbarPage(
  title = 'COVID-19 Literature Review',
  position = c("fixed-top"),
  tabPanel(
      'Included',
      id="tab-panel",
      shinyjs::useShinyjs(),
      fluidRow(
        column(3, 
               filterPanel,
               wellPanel(style = "overflow-y:auto; max-height:350px", htmlOutput("ref_caption"))
        ),
        column(9, withSpinner(DT::dataTableOutput("ex1")))
      )
  ),
  navbarMenu("About",
    tabPanel("The Project",
           tags$style(type="text/css","body {padding-top:60px;padding-bottom:15px;} #smallImage {max-width: 1200px; width: 100%; height: auto; display: block;margin-left: auto;margin-right: auto} #collapseGroup {max-width:1000px;maxheight:200px;width: 100%;margin-left: auto;margin-right: auto} .shiny-notification {position: fixed;left:5px;bottom:5px}"),
           fluidRow(column(3),
              column(6,wellPanel(
                HTML(includeMarkdown("markdown/About-Proj.md")),
                img(src="team.png", id="smallImage"),
                HTML(includeMarkdown("markdown/About-Proj2.md"))
              )),
             column(3))
    ),
    tabPanel('Methods',
           fluidRow(column(3),
                    column(6,wellPanel(HTML(includeMarkdown("markdown/Methods.md")))),
                    column(3))
    ),
    tabPanel('Updates',
             bsCollapse(id = "collapseGroup", 
                        bsCollapsePanel("Website Updates", includeMarkdown("markdown/update_list.md"), style = "primary"),
                        bsCollapsePanel("Search Updates", includeMarkdown("markdown/search_list.md"), style = "primary")
             ),
             img(src="pending.png" , id="smallImage"),
             img(src="facet.png" , id="smallImage")
    ),
    tabPanel('Collaborations',
           fluidRow(column(3),
                    column(6,wellPanel(HTML(includeMarkdown("markdown/Media.md")))),
                    column(3))
    )
  ),
  collapsible = TRUE,
  theme = "yeti.css",
  header = tags$head(includeHTML(("google-analytics.html")), tags$link(rel="shortcut icon", href="favicon.ico")),
  footer = tags$footer(tags$style(".fab-twitter-square {color:#1DA1F2} #gitlink * {color:#808080} #twit {background-color:WhiteSmoke}"), fixedPanel(id="twit", tags$a(href="https://www.twitter.com/covidreview", target="_blank", tagList(icon("twitter-square"), "@covidreview"), align = "center"), tags$a(href="https://www.github.com/jzpero/covidreview", target="_blank", tagList(icon("github"), "Github"), align = "center", id="gitlink"), bottom=0, right=5))
)
