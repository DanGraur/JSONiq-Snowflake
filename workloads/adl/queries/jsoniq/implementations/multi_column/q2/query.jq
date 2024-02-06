import module namespace hep = "../../common/function_subset.jq";

let $filtered := collection("adl").Jet[].pt

return hep:histogram($filtered, 15, 60, 100)
