EXEC sp_addmessage 
    @msgnum = 50005 
    @severity = 1, 
    @msgtext = 'A custom error message'

SELECT    
    *
FROM    
    sys.messages
WHERE 
    message_id = 50005

RAISERROR ( 50005,1,1)
SELECT
    definition,
    uses_ansi_nulls,
    uses_quoted_identifier,
    is_schema_bound
FROM
    sys.sql_modules
WHERE
    object_id
    = object_id(
            'sales.daily_sales'
        );
SELECT 
    OBJECT_DEFINITION(
        OBJECT_ID(
            'sales.staff_sales'
        )
    ) view_info;