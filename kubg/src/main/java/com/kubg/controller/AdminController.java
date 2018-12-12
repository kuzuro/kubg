package com.kubg.controller;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kubg.domain.CategoryVO;
import com.kubg.domain.GoodsVO;
import com.kubg.domain.GoodsViewVO;
import com.kubg.service.AdminService;
import com.kubg.utils.UploadFileUtils;

import net.sf.json.JSONArray;

@Controller
@RequestMapping("/admin/*")
public class AdminController {

	private static final Logger logger = LoggerFactory.getLogger(AdminController.class);
	
	@Inject
	AdminService adminService;
	
	@Resource(name="uploadPath")
	private String uploadPath;
	
	// 관리자화면
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public void getIndex() throws Exception {
		logger.info("get index");
	}

	// 상품 등록
	@RequestMapping(value = "/goods/register", method = RequestMethod.GET)
	public void getGoodsRegister(Model model) throws Exception {
		logger.info("get goods register");
		
		List<CategoryVO> category = null;  // CatagoryVO 형태의 List형 변수 category 선언
		category = adminService.category();  // DB에 저장된 카테고리를 가져와서 category에 저장
		model.addAttribute("category", JSONArray.fromObject(category));  // 변수 category를 제이슨(json)타입으로 변환하여 category 세션에 부여
	}

	
	// 상품 등록
	@RequestMapping(value = "/goods/register", method = RequestMethod.POST)
	public String postGoodsRegister(GoodsVO vo, MultipartFile file) throws Exception {
		
		String imgUploadPath = uploadPath + File.separator + "imgUpload";  // 이미지를 업로드할 폴더를 설정 = /uploadPath/imgUpload 
		String ymdPath = UploadFileUtils.calcPath(imgUploadPath);  // 위의 폴더를 기준으로 연월일 폴더를 생성
		String fileName = null;  // 기본 경로와 별개로 작성되는 경로 + 파일이름
		
		if(file != null) {  // 첨부된 파일이 있으면(!=null)
			fileName =  UploadFileUtils.fileUpload(imgUploadPath, file.getOriginalFilename(), file.getBytes(), ymdPath);
			
		} else {  // 첨부된 파일이 없으면
			fileName = uploadPath + File.separator + "images" + File.separator + "none.png";
			// 미리 준비된 none.png파일을 대신 출력함
		}
		
		// gdsImg에 원본 파일 경로 + 파일명 저장
		vo.setGdsImg(File.separator + "imgUpload" + ymdPath + File.separator + fileName);
		// gdsThumbImg에 썸네일 파일 경로 + 썸네일 파일명 저장
		vo.setGdsThumbImg(File.separator + "imgUpload" + ymdPath + File.separator + "s" + File.separator + "s_" + fileName);
				
		adminService.register(vo);
		
		return "redirect:/admin/index";
	}
		  
	// 상품 목록
	@RequestMapping(value = "/goods/list", method = RequestMethod.GET)
	public void getGoodsList(Model model) throws Exception {
		logger.info("get goods list");
		
		List<GoodsVO> list = adminService.goodslist();  // GoodsVO형태의 List형 변수 list 선언
		
		model.addAttribute("list", list);  // 변수 list의 값을 list 세션에 부여
	}
	
	// 상품 조회
	@RequestMapping(value = "/goods/view", method = RequestMethod.GET)
	public void getGoodsview(@RequestParam("n") int gdsNum, Model model) throws Exception {
		logger.info("get goods view");
		
		GoodsViewVO goods = adminService.goodsView(gdsNum);
		model.addAttribute("goods", goods);
	}
	
	// 상품 수정
	@RequestMapping(value = "/goods/modify", method = RequestMethod.GET)
	public void getGoodsModify(@RequestParam("n") int gdsNum, Model model) throws Exception {
	// @RequestParam("n")으로 인해, URL주소에 있는 n의 값을 가져와 gdsNum에 저장
		
		logger.info("get goods modify");
		
		GoodsViewVO goods = adminService.goodsView(gdsNum);  // GoodsViewVO형태 변수 goods에 상품 정보 저장
		model.addAttribute("goods", goods);
		
		List<CategoryVO> category = null;
		category = adminService.category();
		model.addAttribute("category", JSONArray.fromObject(category));
	}
	
	// 상품 수정
	@RequestMapping(value = "/goods/modify", method = RequestMethod.POST)
	public String postGoodsModify(GoodsVO vo, MultipartFile file, HttpServletRequest req) throws Exception {
		logger.info("post goods modify");
	
		// 새로운 파일이 등록되었는지 확인
		if(file.getOriginalFilename() != null && file.getOriginalFilename() != "") {
			// 기존 파일을 삭제
			new File(uploadPath + req.getParameter("gdsImg")).delete();
			new File(uploadPath + req.getParameter("gdsThumbImg")).delete();
			
			// 새로 첨부한 파일을 등록
			String imgUploadPath = uploadPath + File.separator + "imgUpload";
			String ymdPath = UploadFileUtils.calcPath(imgUploadPath);
			String fileName = UploadFileUtils.fileUpload(imgUploadPath, file.getOriginalFilename(), file.getBytes(), ymdPath);
			
			vo.setGdsImg(File.separator + "imgUpload" + ymdPath + File.separator + fileName);
			vo.setGdsThumbImg(File.separator + "imgUpload" + ymdPath + File.separator + "s" + File.separator + "s_" + fileName);
			
		} else {  // 새로운 파일이 등록되지 않았다면
			// 기존 이미지를 그대로 사용
			vo.setGdsImg(req.getParameter("gdsImg"));
			vo.setGdsThumbImg(req.getParameter("gdsThumbImg"));
			
		}
		
		adminService.goodsModify(vo);
		
		return "redirect:/admin/index";
	}
	
	// 상품 삭제
	@RequestMapping(value = "/goods/delete", method = RequestMethod.POST)
	public String postGoodsDelete(@RequestParam("n") int gdsNum) throws Exception {
	// @RequestParam("n")으로 인해, URL주소에 있는 n의 값을 가져와 gdsNum에 저장
	
		logger.info("post goods delete");
	
		adminService.goodsDelete(gdsNum);
		
		return "redirect:/admin/index";
	}
	
} 
 