show databases;

use test_schema;

create table workflowimport (
    id int,
    name varchar(255));

# Query the table
select * from workflowimport;

# Drop the value in the table
truncate table workflowimport;