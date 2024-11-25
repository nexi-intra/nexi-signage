"use client"
import { DatabaseItemsViewer } from "@/app/koksmat/src/v.next/components/database-items-viewer";
import { databaseQueries } from "@/app/signage/schemas/database";

export function ToolGroupsList() {
  const view = databaseQueries.getView("toolgroups")
  return (
    <DatabaseItemsViewer
      schema={view.schema}

      viewName={"toolgroups"} />
  )
}

