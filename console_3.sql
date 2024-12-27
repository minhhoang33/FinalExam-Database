/* Phần A: 10 Câu Hỏi Truy Vấn (SELECT)
Câu 1
Đề bài:
Hãy liệt kê tất cả người dùng (Users) kèm tổng số Achievements mà mỗi người đã đạt được.

Hiển thị các cột:
User_ID, Username, Email
Tổng số Achievements (nếu chưa có Achievement nào, hiển thị 0)
Sắp xếp giảm dần theo tổng Achievements. */
SELECT
    u.User_ID,
    u.Username,
    u.Email,
    COALESCE(COUNT(a.Achievement_ID), 0) AS Total_Achievements
FROM
    Users u
        LEFT JOIN
    Achievements a ON u.User_ID = a.User_ID
GROUP BY
    u.User_ID
ORDER BY
    Total_Achievements DESC;


/* Câu 2
Đề bài:
Hãy liệt kê các khoá học (Courses) kèm tên Admin đã tạo chúng.

Các cột cần hiển thị:
Course_ID, Name, Fee, Start_Date, End_Date
Username (Admin)
Chỉ lấy các khoá được tạo bởi người dùng có Role = ‘Admin’. */
SELECT
    c.Course_ID,
    c.Name,
    c.Fee,
    c.Start_Date,
    c.End_Date,
    u.Username AS Admin
FROM
    Courses c
        JOIN
    Users u ON c.Created_By = u.User_ID
WHERE
    u.Role = 'Admin';



/* Câu 3
Đề bài:
Thống kê OnlineCourses cho từng Admin, tính trung bình (AVG) Fee của các khoá đó.

Các cột cần hiển thị:
User_ID, Username (của Admin),
Tổng số khoá online đã tạo,
Trung bình phí (AvgFee).
Nhóm theo Admin.*/
SELECT
    u.User_ID,
    u.Username,
    COUNT(oc.OnlineCourse_ID) AS Total_Courses,
    AVG(oc.Fee) AS AvgFee
FROM
    Users u
        JOIN
    OnlineCourses oc ON u.User_ID = oc.Created_By
WHERE
    u.Role = 'Admin'
GROUP BY
    u.User_ID, u.Username;




/* Câu 4
Đề bài:
Với mỗi PracticeSection, hãy lấy:

Section_ID, Name, số lượng PracticeBooks chứa trong Section, và tổng số PracticeTests thuộc các Book trong Section đó.
Kết quả vẫn liệt kê cả những Section không có Book hay Test.*/
SELECT
    ps.Section_ID,
    ps.Name,
    COUNT(pb.Book_ID) AS Total_Books,
    COALESCE(SUM(pt.Test_ID), 0) AS Total_Tests
FROM
    PracticeSections ps
        LEFT JOIN
    PracticeBooks pb ON ps.Section_ID = pb.Section_ID
        LEFT JOIN
    PracticeTests pt ON pb.Book_ID = pt.Book_ID
GROUP BY
    ps.Section_ID;



/* Câu 5
Đề bài:
Lấy danh sách Questions kèm thông tin TestPart và PracticeTest mà câu hỏi đó thuộc về.

Các cột hiển thị:
Question_ID, Content, Correct_Answer
TestPartName (Name của TestPart)
PracticeTestTitle (Title của PracticeTest)*/
SELECT
    q.Question_ID,
    q.Content,
    q.Correct_Answer,
    tp.Name AS TestPartName,
    pt.Title AS PracticeTestTitle
FROM
    Questions q
        JOIN
    TestParts tp ON q.Part_ID = tp.Part_ID
        JOIN
    PracticeTests pt ON tp.Test_ID = pt.Test_ID;




/* Câu 6
Đề bài:
Tìm tất cả Explanations, kèm nội dung câu hỏi (Questions) tương ứng.

Các cột hiển thị:
Explanation_ID, Details, Reference_Link
Question_ID, Content (nội dung câu hỏi)*/
SELECT
    e.Explanation_ID,
    e.Details,
    e.Reference_Link,
    q.Question_ID,
    q.Content
FROM
    Explanations e
        JOIN
    Questions q ON e.Question_ID = q.Question_ID;



/* Câu 7
Đề bài:
Thống kê ExamHistory của các User, tính tổng số lần làm bài và điểm trung bình (AVG Score) của họ.

Chỉ hiển thị những User nào đã có ít nhất 1 bài trong ExamHistory.
Các cột hiển thị:
User_ID, Username, TimesTaken (số lần), AvgScore (điểm trung bình).*/
SELECT
    u.User_ID,
    u.Username,
    COUNT(eh.History_ID) AS TimesTaken,
    AVG(eh.Score) AS AvgScore
FROM
    Users u
        JOIN
    ExamHistory eh ON u.User_ID = eh.User_ID
GROUP BY
    u.User_ID, u.Username
HAVING
    TimesTaken > 0;



/* Câu 8
Đề bài:
Liệt kê chi tiết từng dòng trong ExamResultDetails (kết quả chi tiết khi User làm bài).

Đồng thời hiển thị Username của người dùng đó.
Các cột hiển thị:
Result_ID, Question_ID, User_Answer, Correct_Answer, Is_Correct, Username*/
SELECT
    erd.Result_ID,
    erd.Question_ID,
    erd.User_Answer,
    erd.Correct_Answer,
    erd.Is_Correct,
    u.Username
FROM
    ExamResultDetails erd
        JOIN
    Users u ON erd.User_ID = u.User_ID;


/* Câu 9
Đề bài:
Liệt kê các EntranceExamResults, kèm loại bài thi đầu vào (Exam_Type).

Các cột hiển thị:
Result_ID, User_ID, Exam_Type, Score, Date_Taken, Recommendation
Sắp xếp theo thứ tự mới nhất trước (Date_Taken DESC).*/
SELECT
    eer.Result_ID,
    eer.User_ID,
    ee.Exam_Type,
    eer.Score,
    eer.Date_Taken,
    eer.Recommendation
FROM
    EntranceExamResults eer
        JOIN
    EntranceExam ee ON eer.Exam_ID = ee.Exam_ID
ORDER BY
    eer.Date_Taken DESC;


/* Câu 10
Đề bài:
Liệt kê Documentation kèm tên người tạo (Username), chỉ lấy những tài liệu có Document_Type = ‘PracticeSection’.

Các cột hiển thị:
Document_ID, Title, Document_Type, Created_At, Creator (Username)
Sắp xếp giảm dần theo thời gian tạo (Created_At).*/
SELECT
    d.Document_ID,
    d.Title,
    d.Document_Type,
    d.Created_At,
    u.Username AS Creator
FROM
    Documentation d
        JOIN
    Users u ON d.Created_By = u.User_ID
WHERE
    d.Document_Type = 'PracticeSection'
ORDER BY
    d.Created_At DESC;

/*Phần B: 5 Câu Hỏi Về Trigger
Trigger 1
Đề bài: Mỗi khi thêm (INSERT) mới một User, nếu Created_At để trống, hãy tự động gán giá trị NOW() (thời điểm hiện tại).*/
CREATE TRIGGER set_created_at
    BEFORE INSERT ON Users
    FOR EACH ROW
BEGIN
    IF NEW.Created_At IS NULL THEN
        SET NEW.Created_At = NOW();
    END IF;
END;

/*Trigger 2
Đề bài: Cấm Role = 'Anonymous' tạo News.
Tức là BEFORE INSERT vào News, nếu Created_By là một User có Role = 'Anonymous' thì phải báo lỗi hoặc hủy giao dịch (ROLLBACK).*/
CREATE TRIGGER prevent_anonymous_news
    BEFORE INSERT ON News
    FOR EACH ROW
BEGIN
    DECLARE user_role VARCHAR(255);
    SELECT Role INTO user_role FROM Users WHERE User_ID = NEW.Created_By;
    IF user_role = 'Anonymous' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Anonymous users cannot create news';
    END IF;
END;


/*Trigger 3
Đề bài: Khi xóa một bản ghi trong ExamHistory, hãy xóa luôn ExamResultDetails tương ứng (thay thế cho ON DELETE CASCADE).
Tức là AFTER DELETE trên ExamHistory: xóa tất cả ExamResultDetails có History_ID = OLD.History_ID.*/
CREATE TRIGGER delete_exam_result_details
    AFTER DELETE ON ExamHistory
    FOR EACH ROW
BEGIN
    DELETE FROM ExamResultDetails WHERE History_ID = OLD.History_ID;
END;


/* Trigger 4
Đề bài: Khi thêm một OnlineCourses, chỉ cho phép người dùng có Role = 'Admin'.
 BEFORE INSERT trên OnlineCourses, nếu Created_By thuộc một User không phải Admin thì báo lỗi.*/
CREATE TRIGGER only_admin_create_online_courses
    BEFORE INSERT ON OnlineCourses
    FOR EACH ROW
BEGIN
    DECLARE user_role VARCHAR(255);
    SELECT Role INTO user_role FROM Users WHERE User_ID = NEW.Created_By;
    IF user_role != 'Admin' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only Admin users can create OnlineCourses';
    END IF;
END;



/*Trigger 5
Đề bài: Khi thêm mới vào ExamHistory, hãy tự động ghi Recommendation dựa trên Score.
Nếu Score < 5 => 'Cần ôn tập lại'
Nếu Score >= 5 => 'Có thể chuyển lên cấp cao hơn'*/
CREATE TRIGGER set_exam_recommendation
    BEFORE INSERT ON ExamHistory
    FOR EACH ROW
BEGIN
    IF NEW.Score < 5 THEN
        SET NEW.Recommendation = 'Cần ôn tập lại';
    ELSE
        SET NEW.Recommendation = 'Có thể chuyển lên cấp cao hơn';
    END IF;
END;



/*Phần C: 5 Câu Hỏi Về Stored Procedure
/* SP 1
Đề bài: Tạo thủ tục thêm mới một User, có tham số đầu vào:

p_Username, p_Password, p_Email, p_Role (có thể là 'Admin', 'User', 'Anonymous')
Nếu p_Role không được truyền vào (NULL), hãy mặc định 'User'.
Khi chèn vào bảng Users, tự động set Created_At = NOW().*/
DELIMITER //
CREATE PROCEDURE AddUser(
    IN p_Username VARCHAR(255),
    IN p_Password VARCHAR(255),
    IN p_Email VARCHAR(255),
    IN p_Role ENUM('Admin', 'User', 'Anonymous')
)
BEGIN
    IF p_Role IS NULL THEN
        SET p_Role = 'User';
    END IF;
    INSERT INTO Users (Username, Password, Email, Role, Created_At)
    VALUES (p_Username, p_Password, p_Email, p_Role, NOW());
END //
DELIMITER ;


  /*  SP 2
Đề bài: Tạo thủ tục cập nhật mật khẩu cho User dựa vào User_ID.

Tham số: p_UserID, p_NewPassword.
UPDATE bảng Users.*/
DELIMITER //
CREATE PROCEDURE UpdatePassword(
    IN p_UserID INT,
    IN p_NewPassword VARCHAR(255)
)
BEGIN
    UPDATE Users
    SET Password = p_NewPassword
    WHERE User_ID = p_UserID;
END //
DELIMITER ;



/* SP 3
Đề bài: Tạo thủ tục lấy danh sách Courses (bảng Courses) kèm tên Admin tạo, sắp xếp theo Fee giảm dần.

Kết quả SELECT hiển thị: Course_ID, Name, Fee, Username (Admin).*/
DELIMITER //
CREATE PROCEDURE GetCourses()
BEGIN
    SELECT
        c.Course_ID,
        c.Name,
        c.Fee,
        u.Username AS Admin
    FROM
        Courses c
            JOIN
        Users u ON c.Created_By = u.User_ID
    ORDER BY
        c.Fee DESC;
END //
DELIMITER ;


  /*  SP 4
Đề bài: Tạo thủ tục thêm mới bản ghi ExamHistory khi người dùng nộp bài.

Tham số: p_UserID, p_TestID, p_TotalQuestions, p_CorrectAnswers.
    Tính Score = (p_CorrectAnswers / p_TotalQuestions) * 10.
Date_Taken = NOW().
Sau khi INSERT, có thể trả về History_ID (nếu hệ CSDL hỗ trợ).*/
DELIMITER //
CREATE PROCEDURE AddExamHistory(
    IN p_UserID INT,
    IN p_TestID INT,
    IN p_TotalQuestions INT,
    IN p_CorrectAnswers INT
)
BEGIN
    DECLARE p_Score FLOAT;
    SET p_Score = (p_CorrectAnswers / p_TotalQuestions) * 10;
    INSERT INTO ExamHistory (User_ID, Test_ID, Date_Taken, Completion_Time, Correct_Answers, Total_Questions, Score)
    VALUES (p_UserID, p_TestID, NOW(), 0, p_CorrectAnswers, p_TotalQuestions, p_Score);
END //
DELIMITER ;


/*Sp5
Đề bài: Tạo thủ tục thống kê cho một User:

  Tổng số Achievements (bảng Achievements)
 Tổng số lần thi (bảng ExamHistory)
 Điểm trung bình (cột Score trong ExamHistory)
 Tham số đầu vào: p_UserID.
  Có thể trả về 3 giá trị thông qua 3 SELECT riêng hoặc qua OUT parameter  */
DELIMITER //
CREATE PROCEDURE StatUserInfo(IN p_UserID INT)
BEGIN
    SELECT
        COUNT(a.Achievement_ID) AS Total_Achievements
    FROM
        Achievements a
    WHERE
        a.User_ID = p_UserID;

    SELECT
        COUNT(eh.History_ID) AS Total_Exams,
        AVG(eh.Score) AS AvgScore
    FROM
        ExamHistory eh
    WHERE
        eh.User_ID = p_UserID;
END //
DELIMITER ;
