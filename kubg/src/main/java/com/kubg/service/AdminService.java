package com.kubg.service;

import java.util.List;

import com.kubg.domain.CategoryVO;
import com.kubg.domain.GoodsVO;

public interface AdminService {

	// 카테고리
	public List<CategoryVO> category() throws Exception;
	
	// 상품등록
	public void register(GoodsVO vo) throws Exception;
		
}