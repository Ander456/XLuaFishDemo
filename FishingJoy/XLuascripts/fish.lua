-- v1.1
local UnityEngine = CS.UnityEngine
xlua.hotfix(CS.Treasour, 'CreatePrize', function(self)
    for i=0,4 do
        local go = UnityEngine.GameObject.Instantiate(self.gold, self.transform.position + UnityEngine.Vector3(-10 + i * 50, 0, 0), self.transform.rotation)
        go.transform.SetParent(go.transform, self.cavas)
        local go1 = UnityEngine.GameObject.Instantiate(self.diamands, self.transform.position + UnityEngine.Vector3(0, 50, 0) + UnityEngine.Vector3(-10 + i * 50, 0, 0), self.transform.rotation)
        go1.transform.SetParent(go1.transform, self.cavas)
    end
end)

xlua.hotfix(CS.Gun, 'Attack', function( self )
    if UnityEngine.Input.GetMouseButtonDown(0) then
        -- v1.2
        if UnityEngine.EventSystems.EventSystem.current:IsPointerOverGameObject() then
            return
        end
        
        -- v1.3
        if self.gunLevel == 3 and self.diamands < 3 then
            return
        elseif self.gunLevel ~= 3 then
            if self.gold < (1 + self.gunLevel - 1)*2 or self.gold == 0 then
                return
            end
        end

        self.bullectAudio.clip = self.bullectAudios[self.gunLevel - 1]
        self.bullectAudio:Play()
        if self.Butterfly then
            UnityEngine.GameObject.Instantiate(self.Bullects[self.gunLevel - 1], self.attackPos.position, self.attackPos.rotation * UnityEngine.Quaternion.Euler(0, 0, 20))
            UnityEngine.GameObject.Instantiate(self.Bullects[self.gunLevel - 1], self.attackPos.position, self.attackPos.rotation * UnityEngine.Quaternion.Euler(0, 0, -20))
        end
        UnityEngine.GameObject.Instantiate(self.Bullects[self.gunLevel - 1], self.attackPos.position, self.attackPos.rotation)
        if not self.canShootForFree then
            if self.gunLevel == 3 then
                self:DiamandsChange(-3)
            else
                self:GoldChange(-1 - (self.gunLevel - 1) * 2)
            end
        end
        self.attackCD = 0
        self.attack = false
    end
end)

-- v1.3
xlua.hotfix(CS.Fire, 'Start', function( self )
    self.reduceDiamands = 8
end)

xlua.hotfix(CS.Ice, 'Start', function( self )
    self.reduceDiamands = 8
end)

xlua.hotfix(CS.ButterFly, 'Start', function( self )
    self.reduceDiamands = 5
end)

local util = require("util")

util.hotfix_ex(CS.Boss, 'Start', function( self )
    self.Start(self)
    self.m_reduceGold = -10
end)

util.hotfix_ex(CS.DeffendBoss, 'Start', function( self )
    self.Start(self)
    self.m_reduceGold = -20
end)

util.hotfix_ex(CS.InvisibleBoss, 'Start', function( self )
    self.Start(self)
    self.m_reduceGold = 0
    self.m_reduceDiamond = -5
end)

util.hotfix_ex(CS.Gun, 'GoldChange', function( self, number )
    self.GoldChange(self, number)
    if self.gold < -number then
        self.gold = 0
    end
end)

util.hotfix_ex(CS.Gun, 'DiamandsChange', function( self, number )
    self.DiamandsChange(self, number)
    if self.diamands < -number then
        self.diamands = 0
    end
end)


local canCreateNewFish = true
local changeMapTimeVal = 0

-- v2.0
xlua.hotfix(CS.CreateFish, 'Start', function( self )
    self.hotFixScript:LoadResource('level3fish3', 'gameobject/emeny.ab')
    self.hotFixScript:LoadResource('SeaWave', 'gameobject/wave.ab')
end)

xlua.hotfix(CS.CreateFish, 'Update', function( self )
    if canCreateNewFish then
        if changeMapTimeVal >= 30 then
            local go = CS.HotFixScript.GetGameObject('SeaWave')
            UnityEngine.GameObject.Instantiate(go)
            canCreateNewFish = false
            changeMapTimeVal = 0
        else
            changeMapTimeVal = changeMapTimeVal + UnityEngine.Time.deltaTime
        end
    else
        return
    end
    self:CreateALotOfFish()
    if (self.ItemtimeVal >= 0.5) then
        self.num = UnityEngine.Mathf.Floor(UnityEngine.Random.Range(0, 4))
        self.ItemNum = UnityEngine.Mathf.Floor(UnityEngine.Random.Range(1, 101))
        local halfLength = self.fishList.Length/2
        local litterFishTypeIndex = UnityEngine.Mathf.Floor(UnityEngine.Random.Range(0, halfLength))
        local bigFishTypeIndex = UnityEngine.Mathf.Floor(UnityEngine.Random.Range(halfLength, self.fishList.Length))
        local itemTypeIndex = UnityEngine.Mathf.Floor(UnityEngine.Random.Range(0, self.item.Length))
        -- generate bubble
        if (self.ItemNum < 20) then
            self:CreateGameObject(self.item[3])
            self:CreateGameObject(self.fishList[6])
        end
        -- generate fish
        if (self.ItemNum <= 42) then
            for i=0,2 do
                self:CreateGameObject(self.fishList[litterFishTypeIndex])
            end
            self:CreateGameObject(self.item[itemTypeIndex])
        elseif (self.ItemNum >= 43 and self.ItemNum < 72) then
            for i=0,1 do
                self:CreateGameObject(self.fishList[bigFishTypeIndex])
            end
            self:CreateGameObject(self.item[itemTypeIndex])
        elseif self.ItemNum >= 73 and self.ItemNum < 83 then
            -- v2.0
            local newFish = CS.HotFixScript.GetGameObject('level3fish3')
            self:CreateGameObject(newFish)
        elseif (self.ItemNum >= 84 and self.ItemNum < 86) then
            self:CreateGameObject(self.boss2)
        elseif (self.ItemNum >= 87 and self.ItemNum <= 88) then
            self:CreateGameObject(self.boss)
        elseif (self.ItemNum >= 84 and self.ItemNum < 86) then
            self:CreateGameObject(self.boss2)
        elseif (self.ItemNum == 100) then
            self:CreateGameObject(self.boss3)
        else
            self:CreateGameObject(self.item[0])
        end
        self.ItemtimeVal = 0
    else
        self.ItemtimeVal = self.ItemtimeVal + UnityEngine.Time.deltaTime
    end
end)

-- v1.4
xlua.hotfix(CS.Fish, 'TakeDamage', function( self, attackValue )
    if (CS.Gun.Instance.Fire) then
        attackValue = attackValue*2
    end
    local catchValue = UnityEngine.Mathf.Floor(UnityEngine.Random.Range(0, 100))
    if catchValue <= (50 - (self.hp - attackValue))/2 then
        self.isDead = true
        for i=0,8 do
            UnityEngine.GameObject.Instantiate(self.pao, self.transform.position, UnityEngine.Quaternion.Euler(self.transform.eulerAngles + UnityEngine.Vector3(0, 45 * i, 0)))
        end
        self.gameObjectAni:SetTrigger("Die")
        self:Invoke("Prize", 0.7)
    end
end)

xlua.hotfix(CS.Boss, 'TakeDamage', function( self, attackValue )
    if (CS.Gun.Instance.Fire) then
        attackValue = attackValue*2
    end
    local catchValue = UnityEngine.Mathf.Floor(UnityEngine.Random.Range(0, 100))
    if catchValue <= (attackValue*3-self.hp/10) then
        UnityEngine.GameObject.Instantiate(self.deadEeffect, self.transform.position, self.transform.rotation)
        CS.Gun.Instance:GoldChange(self.GetGold * 10)
        CS.Gun.Instance:DiamandsChange(self.GetDiamands * 10)
        local itemGo
        for i=0,10 do
            itemGo = UnityEngine.GameObject.Instantiate(self.gold, self.transform.position, UnityEngine.Quaternion.Euler(self.transform.eulerAngles + UnityEngine.Vector3(0, 18 + 36 * (i - 1), 0)))
            itemGo:GetComponent('Gold').bossPrize = true
        end
        for i=0,10 do
            itemGo = UnityEngine.GameObject.Instantiate(self.diamands, self.transform.position, UnityEngine.Quaternion.Euler(self.transform.eulerAngles + UnityEngine.Vector3(0, 36 + 36 * (i - 1), 0)))
            itemGo:GetComponent('Gold').bossPrize = true
        end
        UnityEngine.Object.Destroy(self.gameObject)
    end
end)

xlua.hotfix(CS.Gun, 'RotateGun', function( self )
    if UnityEngine.Input.GetKey(UnityEngine.KeyCode.A) then
        self.transform:Rotate(UnityEngine.Vector3.forward * self.rotateSpeed)
    elseif UnityEngine.Input.GetKey(UnityEngine.KeyCode.D) then
        self.transform:Rotate(-UnityEngine.Vector3.forward * self.rotateSpeed)
    end
    self:ClampAngle()
end)

xlua.hotfix(CS.GunImage, 'RotateGun', function( self )
    if UnityEngine.Input.GetKey(UnityEngine.KeyCode.A) then
        self.transform:Rotate(UnityEngine.Vector3.forward * self.rotateSpeed)
    elseif UnityEngine.Input.GetKey(UnityEngine.KeyCode.D) then
        self.transform:Rotate(-UnityEngine.Vector3.forward * self.rotateSpeed)
    end
    self:ClampAngle()
end)

-- v2.0
xlua.hotfix(CS.HotFixEmpty, 'Start', function( self )
    self:Invoke("BehaviourMethod", 8)
end)

xlua.hotfix(CS.HotFixEmpty, 'Update', function( self )
    self.transform:Translate(-self.transform.right*4*UnityEngine.Time.deltaTime, UnityEngine.Space.World)
end)

xlua.hotfix(CS.HotFixEmpty, 'OnTriggerEnter', function( self, other )
    if other.tag ~= "Untagged" and other.tag ~= "Wall" then
        UnityEngine.Object.Destroy(other.gameObject)
    end
end)

xlua.hotfix(CS.HotFixEmpty, 'BehaviourMethod', function( self )
    CS.Gun.Instance.level = CS.Gun.Instance.level + 1
    if CS.Gun.Instance.level == 4 then
        CS.Gun.Instance.level = 1
    end
    canCreateNewFish = true
    CS.Gun.Instance.changeAudio = true
    UnityEngine.Object.Destroy(self.gameObject)
end)