; Render standalone .svg files inline via snacks.image (code stays visible).
; Only the root <svg> is matched so nested <svg> elements aren't rendered twice.
(document
  root: (element
    (STag (Name) @tag (#eq? @tag "svg"))
    (#set! image.ext "svg")
  ) @image @image.content)
