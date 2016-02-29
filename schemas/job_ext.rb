JOB_TYPES = [
             {"type" => "JSONModel(:import_job) object"},
             {"type" => "JSONModel(:find_and_replace_job) object"},
             {"type" => "JSONModel(:print_to_pdf_job) object"},
             {"type" => "JSONModel(:report_job) object"},
             {"type" => "JSONModel(:container_conversion_job) object"},
             {"type" => "JSONModel(:resync_job) object"}
            ]

{
  "job" => {
    "type" => JOB_TYPES
  }
}
