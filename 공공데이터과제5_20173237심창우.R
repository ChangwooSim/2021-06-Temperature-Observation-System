## 공공데이터의이해 기말프로젝트
## 데이터과학융합스쿨 20173237 심창우

# 패키지 라이브러리 불러오기
install.packages("httr")
install.packages("XML")
library(httr)
library(shiny)
library(XML)

# 공공데이터 API 호출
service_url <- "http://apis.data.go.kr/B552584/UlfptcaAlarmInqireSvc/getUlfptcaAlarmInfo?ServiceKey="
service_key <- "0Hm6lssPI%2FQ0zqZB4o9Ol0IwrqpOKc4OOk1OKNjbNhb6xPOBoAlAs9cGywSHUv6aMKsJoEnQina0x1IUnecOcg%3D%3D"
service_addUrl <- "&serviceKey=&returnType&xml&year&itemCode"

# UI 만들기

ui <- fluidPage(
  titlePanel("공공데이터의 이해 기말프로젝트"),
  sidebarLayout(
    sidebarPanel(
      selectInput("moveName", "권역 선택:",
                    c("서울권역" = "1", "경기 남부권" = "16", "경기 동부권" = "17", "경기 북부권" = "18", "경기 중부권" = "19",
                      "강원 영서북부" = "20", "강원 영서남부" = "21", "강원 영동북부" = "22", "강원 영동남부" = "23")
      ),
      dateInput("date", "날짜 선택:", value = "2021-01-01")
    ),
    
    mainPanel(tableOutput("tab"))
  )
)

server <- function(input, output) {
  
  output$tab <- renderTable({

    # 권역
    moveName <- input$moveName
    
    # 년/월/일 입력
    date <-format(input$issueDate, "%Y%m%d")
    
    # API url
    url <- GET(paste0(service_url, service_key, service_addUrl, '&issueDate=', date, '&clearDate=', date, '&moveNames=', moveName))
    
    # XML 파싱
    doc <- xmlTreeParse(url, useInternalNodes = T, encoding = "UTF-8")

    rootNode <- xmlRoot(doc)
    items <- rootNode[[2]][['items']]

    df <- xmlToDataFrame(items)[,c("itemCode","issueVal", "clearVal")]
      })
}

shinyApp(ui, server)