// theme colors and fonts
#let tpt_red = rgb("#BF1238")
#let tpt_red_grad = rgb("#FA3061")

#let theme_background = tpt_red
#let theme_background_grad = tpt_red_grad
#let tpt_logo = image("img/logo-tp-ipp.svg", width: 60%)

#let font = "Marianne"

// only states can be modified from a function
#let author_in_slides = state("author_in_slides", none)
#let date_in_slides   = state("date_in_slides", none)
#let title_in_slides  = state("title_in_slides", none)


#let slides(
            // slides fromat, default 16x10
             beamer_format : (16,10),
             // presentation title
             title: [Slides title],
             // optionnal subtitle
             subtitle: none,
             // TODO: athors list ()
             author: none,
             // optionnal date
             date: none,
             doc
       ) = {
	// Variables for configuration.
	let scale = 2cm
	let width = beamer_format.at(0) * scale
	let height = beamer_format.at(1) * scale
        let heading_left_margin = 2cm

	// Setup.
	set document(
		title: title,
		author: author,
	)
	set text(
		font: font,
		size: 25pt,
	)
	set page(
		width: width,
		height: height,
		margin: 0pt,
	)

        // TODO: have a short version of thoses if defined
        title_in_slides.update(title)
        author_in_slides.update(author)
        date_in_slides.update(date)

	set align(left + horizon)

        // section page
	show heading.where(level: 1): title => {
		pagebreak(weak: true)
		rect(
			width: 100%, height: 100%,
			//fill: gradient.linear(theme_background, theme_background_grad),
                        pad(x: heading_left_margin, {
                              text(fill: tpt_red, title)
                              //"xxx level: "+ str(title.level)
                        })
		)
		counter(page).update(x => x - 1)
		pagebreak(weak: true)
	}

	// Title page.
	rect(
		width: 100%, height: 100%,
                fill: gradient.linear(theme_background, theme_background_grad, angle: 90deg),
		{
                  pad(x: heading_left_margin, {
                        set text(fill: white)
			text(size: 50pt, weight: "bold", title)
			linebreak()
      
      v(1em)
			
      text(size: 30pt, subtitle)
			v(2em)
			text(size: 25pt, author)
			linebreak()
			text(size: 15pt, date)
                      })
		}
	)
	pagebreak(weak: true)
	counter(page).update(1)

	// Actual content.
	doc
}

#let slide(title: "", show_footer: true, content) = context {
        let band_width = 3.2cm
        let loc = here()
	// Header with slide title.
	let header = {
		let headers = query(selector(heading.where(level:1)).before(loc))
                 set align(left + top)
                 set text(fill: tpt_red, weight: "bold")
                 pad(x: 0pt, y: 32pt,{
                      if headers == () {
                          text(size: 36pt, title)
                      } else {
                          let section = headers.last().body
                          if title == "" {
                                  text(size: 36pt, section)
                          } else {
                                  text(size: 14pt, section)
                                  linebreak()
                                  text(size: 28pt, title)
                          }
                      }
                    })
	}

	// Footer with left and right section.
	let footer = grid(columns: (1fr, auto),
          // Presentation title and author.
          pad(x: 10pt, y: 10pt,
                grid(
                  row-gutter: 0.25em,
                  text(size:13pt, title_in_slides.get()),
                 if date_in_slides.at(loc) != none {
                   text(size:10pt, author_in_slides.get() + " - " + date_in_slides.get())
                 } else {
                   text(size:10pt, author_in_slides.get())
                 }
               )
          ),
          // Page counter.
          rect(
            width: 60pt,
            height: 40pt,
            fill: theme_background,
            align(
              center + horizon,
              text(20pt, fill: white, counter(page).display())
              )
            )
	)

        let leftpan = {
          rect(
            width:100%, height:100%, fill: gray.lighten(90%),
            align(
              center + top,
              pad(x: 0pt, y: 16pt, tpt_logo)
            )
          )
        }

	pagebreak(weak: true)
        grid(
          columns : (band_width, 1fr),
          gutter: 32pt,
          leftpan,
          grid(rows: (auto, 1fr, auto), {
            header
            }, {
              // Inner slide content.
              pad(x: 10pt, y: 10pt, box(align(left, content)))
            }, {
              if show_footer { footer }
            })
          )
}

#let outline_slide(title: none) = {

  let stitle = "Outline"
  if title != none {
   stitle = title
  }

  slide(title: stitle, show_footer: false)[
    #box(
      width : 95%,
      outline( title: none, depth: 1, indent: 2em)
        )
  ]
  counter(page).update(x => x - 1)
}
