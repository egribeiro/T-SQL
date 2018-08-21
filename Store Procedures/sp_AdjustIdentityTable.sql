IF OBJECT_ID(N'sp_AdjustIdentityTable',N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[sp_AdjustIdentityTable]
GO
-- ===========================================================================
-- Author: Edson Ribeiro
-- Create date: 2018/08/19
-- Description: Sometimes after insert into table, the identity column jump 
-- a range numbers and it to be ajusted with this procedure.
-- ===========================================================================
CREATE PROCEDURE [dbo].[sp_AdjustIdentityTable]
(
	@Table VARCHAR(100) 
)
AS
BEGIN
	
	--No count in session
	SET NOCOUNT ON;
	
-- ============================================================================================================================================================
--	Variables of process
-- ============================================================================================================================================================
	BEGIN 
	
		DECLARE 
			@Id1         VARCHAR(5)     = '',
			@Id2         VARCHAR(5)     = '',
			@SQL         NVARCHAR(MAX)  = '',
			@Parameters  NVARCHAR(500)  = '',  
			@Column      VARCHAR(50)    = ''
	
	END
-- ============================================================================================================================================================
--	Begin process
-- ============================================================================================================================================================
	BEGIN
	
		--Get identity column of table
		SELECT 
			@Column = c.name
		FROM SYS.columns        AS C
		INNER JOIN SYS.tables   AS T ON T.object_id = C.object_id
		WHERE   
			T.name = @Table
		AND
			C.is_identity = 1

		IF ISNULL(@Column,'') != ''
			BEGIN

				--Get current identity of column 
				SELECT @Id1 = CAST(IDENT_CURRENT (@Table) + 1 AS VARCHAR(10))
				 
				--Get last Id(Identity of the column)
				SET @SQL = CONCAT('
									SELECT 
										@Id2OUT = CAST(MAX(',@Column,') + 1 AS VARCHAR(10)) 
									FROM ',@Table,'
									 
								')
				SET @Parameters = '@Id2OUT VARCHAR(5)'
				
				EXECUTE sp_ExecuteSQL   @SQL, 
										@Parameters,
										@Id2OUT = @UCod2 OUTPUT;  

				--Checking if SGBD identity is bigger than last inserted in the table.
				IF CAST(@Id1 AS INT) > CAST(@UCod2 AS INT)
				BEGIN
					SET @SQL = CONCAT(' DBCC CHECKIDENT (',@Table,', reseed, ',@UCod2,') ') 
					EXEC ExecuteSQL @SQL
				END
			END
	END
		
END