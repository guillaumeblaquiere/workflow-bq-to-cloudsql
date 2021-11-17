# Overview

This workflow performs an export of data from BigQuery with the 
[export statement](https://cloud.google.com/bigquery/docs/reference/standard-sql/other-statements) and store the result 
in Cloud Storage. The export files are imported, one by one to Cloud SQL. It's the purpose of this 
[Medium article](https://medium.com/google-cloud/replicate-data-from-bigquery-to-cloud-sql-2b23a08c52b1)

# Customization

At the top of the `import.yaml` file, the assignment step allows you configuring the following parameters:

* **bucket**: The bucket to store the export files
* **prefix**: The export file prefix in the export bucket. Can contain path (`path/to/file-prefix`)
* **projectid**: The project ID
* **query**: The BigQuery query to perform to get and format the data correctly
* **instance**: The name of the Cloud SQL instance
* **databaseschema**: The schema name inside the Cloud SQL instance
* **importtable**: The table name in the schema. The data will be imported there, the table schema must fit your 
export file content.

You can also use [Workflow parameters](https://cloud.google.com/workflows/docs/passing-runtime-arguments) to set them 
dynamically at execution time.

# Deployment

Create a service account with the required permission:

```
# Create the service account
gcloud iam service-accounts create import-workflow

# Grant the permissions
gcloud projects add-iam-policy-binding <PROJECT_ID> --member="serviceAccount:import-workflow@<PROJECT_ID>.iam.gserviceaccount.com" --role="roles/cloudsql.admin" --condition=None
gcloud projects add-iam-policy-binding <PROJECT_ID> --member="serviceAccount:import-workflow@<PROJECT_ID>.iam.gserviceaccount.com" --role="roles/storage.admin" --condition=None
gcloud projects add-iam-policy-binding <PROJECT_ID> --member="serviceAccount:import-workflow@<PROJECT_ID>.iam.gserviceaccount.com" --role="roles/bigquery.dataViewer" --condition=None
gcloud projects add-iam-policy-binding <PROJECT_ID> --member="serviceAccount:import-workflow@<PROJECT_ID>.iam.gserviceaccount.com" --role="roles/bigquery.jobUser" --condition=None
```

Deploy to Workflow 
```
gcloud workflows deploy import --source=import.yaml --service-account=import-workflow@<PROJECT_ID>.iam.gserviceaccount.com
```

# Execution

Before running the execution, be sure that:

* Your Cloud SQL instance is running
* The schema and the table existing in the instance
* The table schema is correct according to your BigQuery export

Trigger your Workflow execution (add arguments if you update the workflow in the customization step)
``` 
gcloud workflows execute import
```

The command line provide you the link to follow the execution results. Wait 1 minutes and check the result.
You can also check your Cloud SQL database to see the import result.

# License

This library is licensed under Apache 2.0. Full license text is available in
[LICENSE](https://github.com/guillaumeblaquiere/cloudrun-cloudfunction-compare/tree/master/LICENSE).