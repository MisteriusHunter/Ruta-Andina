package com.rutaandina.dto;

import java.util.List;
import java.util.Map;

public class BiQueryResultDto {
    private Integer queryId;
    private String title;
    private String description;
    private String sql;
    private List<String> columns;
    private List<Map<String, Object>> rows;
    private Long executionTimeMs;
    private Integer totalRows;

    public BiQueryResultDto() {}

    public Integer getQueryId() { return queryId; }
    public void setQueryId(Integer queryId) { this.queryId = queryId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSql() { return sql; }
    public void setSql(String sql) { this.sql = sql; }

    public List<String> getColumns() { return columns; }
    public void setColumns(List<String> columns) { this.columns = columns; }

    public List<Map<String, Object>> getRows() { return rows; }
    public void setRows(List<Map<String, Object>> rows) { this.rows = rows; }

    public Long getExecutionTimeMs() { return executionTimeMs; }
    public void setExecutionTimeMs(Long executionTimeMs) { this.executionTimeMs = executionTimeMs; }

    public Integer getTotalRows() { return totalRows; }
    public void setTotalRows(Integer totalRows) { this.totalRows = totalRows; }
}
