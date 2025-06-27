#import "template.typ": *

#show: doc => slides(
  title:"Slides title",
  subtitle: "My subtitle",
  author: "Grégor QUETEL",
  date: "01 janvier 2025",
  doc
)

#show link: l => underline(l)

#outline_slide()