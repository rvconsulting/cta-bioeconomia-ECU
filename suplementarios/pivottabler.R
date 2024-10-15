# Test Ground
# Duck DB

library(dplyr)


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

