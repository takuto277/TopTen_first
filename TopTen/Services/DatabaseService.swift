//
//  DatabaseService.swift
//  TopTen
//
//  Created by 小野拓人 on 2024/02/29.
//

import Foundation
import SQLite3
import FMDB

enum myError: Error {
    case case1
}

final class DatabaseService {
    static let shared = DatabaseService()
    
    let database:FMDatabase?
    
    private init(){
        // データベースファイルのパスを取得
        let databasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/mydatabase.db")
        print(databasePath)
        
        // FMDatabaseオブジェクトを作成
        database = FMDatabase(path: databasePath)
        
        self.createTable()
    }
    
    private func createTable() {
        guard let database = self.database else { return }
        // データベースを開く
        if database.open() {
            // テーブルの作成
            let createTableSQLOfThemeData = """
        CREATE TABLE IF NOT EXISTS theme_data (
                id TEXT NOT NULL PRIMARY KEY,
                theme TEXT NOT NULL,
                low_number_theme TEXT NOT NULL,
                high_number_theme TEXT NOUT NULL,
                delete_flg TEXT NOT NULL
        )
        """
            /*
             id: id pk
             theme: お題
             low_number_theme: 低い番号のお題
             high_number_theme: 高い番号のお題
             delete_flg: 削除フラグ
             */
            if database.executeUpdate(createTableSQLOfThemeData, withArgumentsIn: []) {
                print("theme_dataのテーブル作成成功")
            } else {
                print("theme_dataのテーブル作成失敗")
            }
            
            // テーブルの作成
            let createTableSQLOfAnswerData = """
        CREATE TABLE IF NOT EXISTS answer_data(
                id TEXT NOT NULL PRIMARY KEY,
                answer TEXT NOT NULL,
                number TEXT NOT NULL,
                reason TEXT,
                delete_flg TEXT NOT NULL
        )
        """
            /*
             learning_day: 学習日
             year: 年代
             correct_count: 正答数
             total_count: 問題数
             correct_rate: 正答率
             */
            if database.executeUpdate(createTableSQLOfAnswerData, withArgumentsIn: []) {
                print("answer_dataのテーブル作成成功")
            } else {
                print("answer_dataのテーブル作成失敗")
            }
        }
    }
    
    func insertWordData(wordData: WordData) -> Bool {
        guard let database = self.database else { return false}
        // データの挿入
        let insertSQL = """
        INSERT INTO wordData (
        englishWordName, japanWordName, englishSentence, japanSentence, proficiency, priorityNumber, number, deleteFlg, imageURL)
        VALUES (
        :englishWordName, :japanWordName, :englishSentence, :japanSentence, :proficiency, :priorityNumber, :number, :deleteFlg, :imageURL)
        """
        let param = ["englishWordName": wordData.englishWordName,
                     "japanWordName": wordData.japanWordName,
                     "englishSentence": wordData.englishSentence,
                     "japanSentence": wordData.japanSentence,
                     "proficiency": wordData.proficiency,
                     "priorityNumber": wordData.priorityNumber,
                     "number": wordData.number,
                     "deleteFlg": wordData.deleteFlg,
                     "imageURL": wordData.imageURL,] as [String : Any]
        if database.executeUpdate(insertSQL, withParameterDictionary: param as [AnyHashable : Any]) {
            print("データ挿入成功")
            return true
        } else {
            print("データ挿入失敗")
            return false
        }
    }
    
    func updateWordData(wordData: WordData) -> Bool {
        guard let database = self.database else { return false}
        let englishWordName = "WHEN number = \(wordData.number) THEN '\(wordData.englishWordName)'"
        let japanWordName  = "WHEN number = \(wordData.number) THEN '\(wordData.japanWordName)'"
        let englishSentence = "WHEN number = \(wordData.number) THEN '\(wordData.englishSentence)'"
        let japanSentence = "WHEN number = \(wordData.number) THEN '\(wordData.japanSentence)'"
    
    let query = """
        UPDATE wordData
        SET
        englishWordName = CASE
        \(englishWordName)
        END,
        japanWordName = CASE
        \(japanWordName)
        END,
        englishSentence = CASE
        \(englishSentence)
        END,
        japanSentence = CASE
        \(japanSentence)
        END
        WHERE
        number IN (\(wordData.number));
        """
    
    return database.executeUpdate(query, withArgumentsIn: [])
    }
    
    func getWordData(number: Int) throws -> WordData {
        guard let database = self.database else {
            throw myError.case1
        }
        var wordData: WordData?
        // クエリの実行
        let querySQL = "SELECT * FROM wordData"
        if let resultSet = database.executeQuery(querySQL, withArgumentsIn: []) {
            while resultSet.next() {
                guard let englishWordName = resultSet.string(forColumn: "englishWordName"),
                      let japanWordName = resultSet.string(forColumn: "japanWordName"),
                      let englishSentence = resultSet.string(forColumn: "englishSentence"),
                      let japanSentence = resultSet.string(forColumn: "japanSentence"),
                      let proficiency = resultSet.string(forColumn: "proficiency"),
                      let priorityNumber = resultSet.string(forColumn: "priorityNumber"),
                      let deleteFlg = resultSet.string(forColumn: "deleteFlg"),
                      let imageURL = resultSet.string(forColumn: "imageURL") else {
                    throw myError.case1
                }
                let number = Int(resultSet.int(forColumn: "number"))
                wordData = WordData(englishWordName: englishWordName,
                                    japanWordName: japanWordName,
                                    englishSentence: englishSentence,
                                    japanSentence: japanSentence,
                                    proficiency: proficiency,
                                    priorityNumber: priorityNumber,
                                    number: number,
                                    deleteFlg: deleteFlg,
                                    imageURL: imageURL)
                
            }
        }
        guard let wordData = wordData else {
            throw myError.case1
            
        }
        return wordData
        
    }
    
    func getAllWordData() throws -> [WordData] {
        guard let database = self.database else {
            throw myError.case1
        }
        var wordDataArray = [WordData]()
        // クエリの実行
        let querySQL = "SELECT * FROM wordData"
        if let resultSet = database.executeQuery(querySQL, withArgumentsIn: []) {
            while resultSet.next() {
                guard let englishWordName = resultSet.string(forColumn: "englishWordName"),
                      let japanWordName = resultSet.string(forColumn: "japanWordName"),
                      let englishSentence = resultSet.string(forColumn: "englishSentence"),
                      let japanSentence = resultSet.string(forColumn: "japanSentence"),
                      let proficiency = resultSet.string(forColumn: "proficiency"),
                      let priorityNumber = resultSet.string(forColumn: "priorityNumber"),
                      let deleteFlg = resultSet.string(forColumn: "deleteFlg"),
                      let imageURL = resultSet.string(forColumn: "imageURL") else {
                    throw myError.case1
                }
                let number = Int(resultSet.int(forColumn: "number"))
                let wordData = WordData(englishWordName: englishWordName,
                                        japanWordName: japanWordName,
                                        englishSentence: englishSentence,
                                        japanSentence: japanSentence,
                                        proficiency: proficiency,
                                        priorityNumber: priorityNumber,
                                        number: number,
                                        deleteFlg: deleteFlg,
                                        imageURL: imageURL)
                wordDataArray.append(wordData)
                
            }
        }
        return wordDataArray
    }
    
    func getLearningWordData() throws -> [WordData] {
        guard let database = self.database else {
            throw myError.case1
        }
        var wordDataArray = [WordData]()
        // クエリの実行
        let querySQL = """
                        SELECT * FROM wordData
                        WHERE proficiency <> '2'
                        """
        if let resultSet = database.executeQuery(querySQL, withArgumentsIn: []) {
            while resultSet.next() {
                guard let englishWordName = resultSet.string(forColumn: "englishWordName"),
                      let japanWordName = resultSet.string(forColumn: "japanWordName"),
                      let englishSentence = resultSet.string(forColumn: "englishSentence"),
                      let japanSentence = resultSet.string(forColumn: "japanSentence"),
                      let proficiency = resultSet.string(forColumn: "proficiency"),
                      let priorityNumber = resultSet.string(forColumn: "priorityNumber"),
                      let deleteFlg = resultSet.string(forColumn: "deleteFlg"),
                      let imageURL = resultSet.string(forColumn: "imageURL") else {
                    throw myError.case1
                }
                let number = Int(resultSet.int(forColumn: "number"))
                let wordData = WordData(englishWordName: englishWordName,
                                        japanWordName: japanWordName,
                                        englishSentence: englishSentence,
                                        japanSentence: japanSentence,
                                        proficiency: proficiency,
                                        priorityNumber: priorityNumber,
                                        number: number,
                                        deleteFlg: deleteFlg,
                                        imageURL: imageURL)
                wordDataArray.append(wordData)
                
            }
        }
        return wordDataArray
    }
    
    func updateLearningWordData(_ wordDataArray: [WordData]) throws -> Bool {
        guard let database = self.database else {
            throw myError.case1
        }
        var priorityNumberCase = ""
        var proficiencyCase = ""
        var numberCase = ""
        wordDataArray.forEach { wordData in
            priorityNumberCase += " WHEN number = \(wordData.number) THEN '\(wordData.priorityNumber)'"
            proficiencyCase += " WHEN number = \(wordData.number) THEN '\(wordData.proficiency)'"
            numberCase += numberCase == "" ? String(wordData.number) : ", " + String(wordData.number)
        }
        
        let query = """
            UPDATE wordData
            SET
            priorityNumber = CASE
            \(priorityNumberCase)
            END,
            proficiency = CASE
            \(proficiencyCase)
            END
            WHERE
            number IN (\(numberCase));
            """
        
        return database.executeUpdate(query, withArgumentsIn: [])
    }
    
    func getWordDataCount() -> Int {
        var count = 0
        let querySQL = "SELECT COUNT (*) as count FROM wordData"
        if let resultSet = database?.executeQuery(querySQL, withArgumentsIn: []) {
            while resultSet.next() {
                count = Int(resultSet.int(forColumn: "count"))
            }
            return count
        }
        print("英単語数の取得失敗")
        return 0
    }
    
    func databaseClose() {
        guard let database = self.database else { return }
        // データベースを閉じる
        if !database.close() {
            print("データベースオープン失敗")
        }
    }
    
    func insertLearningHistory(learningHistoryData: LearningHistoryData) async throws{
        guard let database = self.database else { throw myError.case1}
        let insertSQL = """
        INSERT INTO LEARNING_HISTORY (
        learning_day, year, correct_count, total_count, correct_rate)
        VALUES (
        :learningDay, :year, :correctCount, :totalCount, :correctRate)
        """
        let param = ["learningDay": learningHistoryData.learningDay,
                     "year": learningHistoryData.year,
                     "correctCount": learningHistoryData.correctCount,
                     "totalCount": learningHistoryData.totalCount,
                     "correctRate": learningHistoryData.correctRate]
        if database.executeUpdate(insertSQL, withParameterDictionary: param as [AnyHashable: Any]) {
            print("LEARNING_HISTORY_データ挿入完了")
        }
    }
    
    func getLearningHistoryDays(year: String) throws -> [String]{
        guard let database = self.database else { throw myError.case1}
        var learningHistoryDays: [String] = []
        let sql = """
                SELECT learning_day FROM LEARNING_HISTORY WHERE year = :year
                """
        let param = ["year": year]
        if let resultSet = database.executeQuery(sql, withParameterDictionary: param) {
            while resultSet.next() {
                guard let day = resultSet.string(forColumn: "learning_day") else { throw myError.case1}
                learningHistoryDays.append(day)
            }
        }
        return learningHistoryDays
    }
}
