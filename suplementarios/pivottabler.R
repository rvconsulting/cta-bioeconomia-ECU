# Test Ground
# Duck DB

library(dplyr)
library("duckdb")

# Save the database to disc

csb_ECU <- read.csv(
  "data/legacy-bio-scn/csb-ECU.csv",
  na.strings="-")

# Let's use a database

con <- dbConnect(duckdb(), dbdir = "outputs/csb_ecu.duckdb", read_only = FALSE)
dbWriteTable(con, "csb_ECU", csb_ECU)
dbDisconnect(con)

# With strings as factors
con <- dbConnect(duckdb(), dbdir = "outputs/csb_ecu_factor.duckdb", read_only = FALSE)
dbWriteTable(con, "csb_ECU", csb.ECU)
dbDisconnect(con)

save(csb_ECU, file="outputs/csb_ECU.RData")
save(csb.ECU, file="outputs/csb_ECU_factor.RData")

load(file="outputs/csb_ECU_factor.RData")

test <- as.data.frame(csb.ECU) |> 
  filter(Año == 2019)


library(pivottabler)

pt <- PivotTable$new()
pt$addData(test)
pt$addColumnDataGroups("Área.transaccional.columnas.No.")
pt$addColumnDataGroups("Área.transaccional", addTotal=FALSE)
pt$addColumnDataGroups("CIIU.Secciones", addTotal=FALSE)
pt$addColumnDataGroups("CIIU.Corto", addTotal=FALSE)
pt$addRowDataGroups("No..Cuadro", addTotal=FALSE)
pt$addRowDataGroups("Cuadro")
pt$addRowDataGroups("Bioeconomía.Productos", totalCaption="Bioeconomía", addTotal=FALSE)
pt$sortColumnDataGroups(levelNumber=2, orderBy="value")
pt$sortRowDataGroups(levelNumber = 2, orderBy = "value")
pt$defineCalculation(calculationName="Gran Total", summariseExpression="sum(Valor, na.rm=TRUE)", format=list(digits=1, nsmall=1, big.mark=",", decimal.mark=".", scientific=FALSE))
pt$renderPivot()

