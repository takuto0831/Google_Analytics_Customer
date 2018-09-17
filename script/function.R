################################## For  Preprocessing ##################################

### function list
# ReadJsonFile: データ内の, json fileをカラムに展開する.
# CheckBinaryColumn: binary value を factor type に変更する(連続値としての情報はない)
# CheckCategoryColumn: uniqueな値が100(要考察)以下の場合, カテゴリカル変数とする
# ImputeMissingValueRF: Random Forest による欠損値補完
# ImputeMissingValueRF: Multiple imputing による欠損値補完
# MakeNewValueTSNE: Rstneによる特徴量作成関数
# SummarizeFunc: データをSK_ID_CURRごとにまとめる関数 (binaryとnumericalで処理を変更する)

########################################################################################

# ReadJsonFile
ReadJsonFile <- function(.data, json_vars){ 
  .data %>% 
    dplyr::select(-dplyr::one_of(json_vars)) %>% 
    dplyr::bind_cols(
      json_vars %>% 
        purrr::map_dfc(
          ~ paste("[", paste(.data[[.x]], collapse = ","), "]") %>% 
            jsonlite::fromJSON(flatten = TRUE))      
    )
}

# CheckBinaryColumn
CheckBinaryColumn <- function(col){
  tmp <- col %>% na.omit() %>% unique()
  # check the binary
  if(length(tmp)<=2) return(TRUE)
  else return(FALSE)
}
# CheckCategoryColumn
CheckCategoryColumn <- function(col){
  tmp <- col %>% na.omit() %>% unique()
  # check the binary
  if(length(tmp) < 100) return(TRUE)
  else return(FALSE)
}
# CheckColumnsNotInclude
CheckColumnsNotInclude <- function(data,patterns){
  ind <- data %>%
    select_if(str_detect(names(.),pattern = paste(patterns,collapse = "|"))) %>% NCOL 
  if(ind == 0) return(TRUE)
  else return(FALSE)
}

# ImputeMissingValueRF (要修正)
ImputeMissingValueRF <- function(data,patterns){
  # parallel processing
  len <- min( dim(data)[2], detectCores()-1)
  cl <- makeCluster(len); registerDoParallel(cl)
  # impute missing values
  imp <- data %>% 
    as.data.frame() %>% 
    missForest(
      variablewise = TRUE, ntree = 100,
      parallelize = "forests", verbose = TRUE) 
  stopCluster(cl)
  # reaname data
  ans <- imp$ximp %>% 
    select(patterns)
  colnames(ans) <- paste(patterns,"_imp",sep = "")
  return(ans)
}

# ImputeMissingValueMI
ImputeMissingValueMI <- function(data,patterns){
  # impute missing value
  cl <- makeCluster(4); registerDoParallel(cl)
  imp <- data %>% 
    as.data.frame() %>% 
    missing_data.frame() %>% 
    mi(n.iter = 30, n.chains = 4, max.minutes = 2000, parallel = TRUE)
  stopCluster(cl)
  # extract value
  tmp <- complete(imp,1:4)
  ans <- data.frame( (tmp$`chain:1` + tmp$`chain:2` + tmp$`chain:3` + tmp$`chain:4`) / 4 ) %>% 
    select_if(!grepl("missing",names(.))) %>% 
    select(patterns)
  # rename data
  colnames(ans) <- paste(patterns,"_imp",sep = "")
  return(ans)
}

# MakeNewValueTSNE
MakeNewValueTSNE <- function(data,patterns){
  set.seed(831) # 再現性の確保
  # MakeNewValueTSNE
  ans <- data %>% 
    Rtsne(check_duplicates = FALSE, verbose=TRUE, theta = 0.5) %>% .$Y
  # rename data
  colnames(ans) <- paste(patterns,"_add",sep = "")
  return(ans)
}

# SummarizeFunc
SummarizeFunc <- function(data,group){
  # for binary
  fn1 <- funs(mean, sum, .args = list(na.rm = TRUE))
  # for numeric
  fn2 <- funs(mean, sum, min, max, sd, .args = list(na.rm = TRUE))
  # summarize 
  tmp1 <- data %>%
    group_by_(group) %>% 
    summarise_if(CheckBinaryColumn,fn1) %>% 
    round(digits = 4) 
  tmp2 <- data %>% 
    group_by_(group) %>% 
    summarise_if(~!CheckBinaryColumn(.x),fn2) %>% 
    round(digits = 4)
  # combine
  cbind(tmp1,tmp2 %>% select(-group)) %>% return()
}
