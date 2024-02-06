import module namespace hep = "../../common/function_subset.jq";

let $filtered :=
  for $event in collection("adl")
  for $jetvar in $event.Jet[]
  where $jetvar.pt gt 40
  let $ev := $event.event
  let $pt := $event.MET.pt
  group by $ev
  where count($jetvar) gt 1
  return $pt

return hep:histogram($filtered, 0, 2000, 100)