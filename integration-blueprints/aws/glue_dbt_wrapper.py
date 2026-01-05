import sys
from awsglue.utils import getResolvedOptions
from dbt.main import main as dbt_main

# Glue Python Shell to run dbt-core against Athena
def run_dbt():
    args = [
        "run",
        "--profiles-dir", "./",
        "--project-dir", "./dbt",
        "--target", "athena"
    ]
    
    # Execute dbt within the Glue context
    res = dbt_main(args)
    if not res.success:
        raise Exception("dbt execution failed")

if __name__ == "__main__":
    run_dbt()
