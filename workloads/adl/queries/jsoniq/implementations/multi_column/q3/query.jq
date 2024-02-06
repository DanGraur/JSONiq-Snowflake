import module namespace hep = "../../common/function_subset.jq";

let $filtered :=
  for $jet in collection("adl").Jet[]
  where abs($jet.eta) lt 1
  return $jet.pt

return hep:histogram($filtered, 15, 60, 100)
