-- v1.1
local UnityEngine = CS.UnityEngine
xlua.hotfix(CS.Treasour, 'CreatePrize', function(self)
    for i=0,4 do
        local go = UnityEngine.GameObject.Instantiate(self.gold, self.transform.position + UnityEngine.Vector3(-10 + i * 30, 0, 0), self.transform.rotation);
        go.transform.SetParent(go.transform, self.cavas)
        local go1 = UnityEngine.GameObject.Instantiate(self.diamands, self.transform.position + UnityEngine.Vector3(0, 30, 0) + UnityEngine.Vector3(-10 + i * 30, 0, 0), self.transform.rotation);
        go1.transform.SetParent(go1.transform, self.cavas)
    end
end)