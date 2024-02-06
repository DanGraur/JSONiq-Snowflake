import module namespace hep = "../../common/function_subset.jq";

let $filtered := collection("adl").MET.pt

return hep:histogram($filtered, 0, 2000, 100)
