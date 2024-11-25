"use client"
import { queries } from "@/app/global";
import { DatabaseItemsViewer } from "@/app/koksmat/src/v.next/components/database-items-viewer";




export function CountryList() {
  const view = queries.getView("countries")
  return (

    <DatabaseItemsViewer
      schema={view.schema}
      viewName={"countries"} />
  )
}

