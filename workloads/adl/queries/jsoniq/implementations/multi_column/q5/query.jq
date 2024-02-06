import module namespace hep = "../../common/function_subset.jq";

let $filtered := (
  for $event in collection("adl")
  where size($event.Muon) gt 1
  for $muon1 at $i in $event.Muon[]
  for $muon2 at $j in $event.Muon[]
  where $i lt $j and $muon1.charge ne $muon2.charge
  let $invariant-mass := sqrt(2 * $muon1.pt * $muon2.pt * ((exp($muon1.eta - $muon2.eta) + exp($muon2.eta - $muon1.eta)) div 2 - cos($muon1.phi - $muon2.phi)))
  where 60 lt $invariant-mass and $invariant-mass lt 120
  let $ev := $event.event
  let $pt := $event.MET.pt
  group by $ev
  return $pt
)

return hep:histogram($filtered, 0, 2000, 100)