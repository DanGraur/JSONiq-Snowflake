import module namespace hep = "../../common/function_subset.jq";

let $filtered := (
  for $event in collection("adl")
  let $filtered-jets := (
    for $jetvar in $event.Jet[]
    where $jetvar.pt gt 30
    where count(
      for $muonvar in $event.Muon[]
      where $muonvar.pt gt 10 and sqrt(
        (($jetvar.phi - $muonvar.phi + pi()) mod (2 * pi()) - pi()) 
        * (($jetvar.phi - $muonvar.phi + pi()) mod (2 * pi()) - pi()) 
        + ($jetvar.eta - $muonvar.eta) 
        * ($jetvar.eta - $muonvar.eta)) lt 0.4
      return 1
    ) eq 0
    where count(
      for $electronvar in $event.Electron[]
      where $electronvar.pt gt 10 and sqrt(
        (($jetvar.phi - $electronvar.phi + pi()) mod (2 * pi()) - pi()) 
        * (($jetvar.phi - $electronvar.phi + pi()) mod (2 * pi()) - pi()) 
        + ($jetvar.eta - $electronvar.eta) 
        * ($jetvar.eta - $electronvar.eta)) lt 0.4
      return 1
    ) eq 0
    return $jetvar.pt
  )
  where size($filtered-jets) gt 0
  let $s := sum($filtered-jets)
  return $s
)

return hep:histogram($filtered, 15, 200, 100)