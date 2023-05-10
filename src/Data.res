// hard coded test data

let rawTree: Visx.D3.treeNode = {
  name: "population",
  children: [
    {
      name: "cites",
      on: "paper_id = cited_paper_id",
      children: [
        {name: "content", on: "citing_paper_id = paper_id"},
        {name: "paper", on: "citing_paper_id = paper_id"},
      ],
    },
    {name: "content", on: "paper_id"},
    {
      name: "cites",
      on: "paper_id = citing_paper_id",
      children: [
        {name: "content", on: "cited_paper_id = paper_id"},
        {name: "paper", on: "cited_paper_id = paper_id"},
      ],
    },
  ],
}
